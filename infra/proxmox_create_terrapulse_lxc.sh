#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# TerraPulse - Proxmox LXC Provisioning Script (Mosquitto + Telegraf + TimescaleDB)
# Run this script directly in the Proxmox VE Node Shell as root.
# ==============================================================================

# --- CONFIGURATION VARIABLES (Adjust as needed) ---
CTID="${CTID:-210}"
HOSTNAME="${HOSTNAME:-terrapulse-iot}"
STORAGE="${STORAGE:-local-lvm}"          # Change to 'local' or 'local-zfs' if needed
BRIDGE="${BRIDGE:-vmbr0}"
ROOT_PASS="${ROOT_PASS:-terrapulse123}"
DB_PASS="${DB_PASS:-terrapulse123}"

echo "[1/7] Checking Debian 12 LXC template..."
pveam update
TEMPLATE=$(pveam available -section system | awk '/debian-12-standard/ {print $2}' | tail -n1)
if ! pveam list local | grep -q "$TEMPLATE"; then
  pveam download local "$TEMPLATE"
fi

echo "[2/7] Creating & starting LXC container $CTID ($HOSTNAME)..."
pct create "$CTID" "local:vztmpl/$TEMPLATE" \
  --hostname "$HOSTNAME" \
  --password "$ROOT_PASS" \
  --storage "$STORAGE" \
  --rootfs "$STORAGE:16" \
  --cores 2 \
  --memory 2048 \
  --swap 512 \
  --net0 "name=eth0,bridge=$BRIDGE,ip=dhcp" \
  --unprivileged 1 \
  --features nesting=1,keyctl=1 \
  --onboot 1 \
  --start 1

sleep 6

echo "[3/7] Installing Docker & Docker Compose inside LXC $CTID..."
pct exec "$CTID" -- bash -c "
  apt-get update && apt-get install -y ca-certificates curl gnupg
  curl -fsSL https://get.docker.com | sh
  mkdir -p /opt/terrapulse/{mosquitto/config,mosquitto/data,mosquitto/log,telegraf,init-db}
"

echo "[4/7] Writing Mosquitto configuration..."
pct exec "$CTID" -- bash -c "cat << 'EOF' > /opt/terrapulse/mosquitto/config/mosquitto.conf
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
listener 1883 0.0.0.0
allow_anonymous true
EOF"

echo "[5/7] Writing TimescaleDB schema, continuous aggregates, and compression policies..."
pct exec "$CTID" -- bash -c "cat << 'EOF' > /opt/terrapulse/init-db/01_init.sql
CREATE EXTENSION IF NOT EXISTS timescaledb;

CREATE TABLE IF NOT EXISTS plant_metrics (
    time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    plant_entity_id TEXT NOT NULL,
    species TEXT,
    plant_state TEXT,
    soil_moisture DOUBLE PRECISION,
    temperature DOUBLE PRECISION,
    air_humidity DOUBLE PRECISION,
    illuminance DOUBLE PRECISION,
    dli DOUBLE PRECISION,
    vapour_pressure_deficit DOUBLE PRECISION,
    moisture_status TEXT,
    temperature_status TEXT,
    illuminance_status TEXT,
    humidity_status TEXT,
    dli_status TEXT,
    vpd_status TEXT,
    battery DOUBLE PRECISION
);

SELECT create_hypertable('plant_metrics', by_range('time', INTERVAL '7 days'), if_not_exists => TRUE);

CREATE INDEX IF NOT EXISTS idx_plant_metrics_entity_time
    ON plant_metrics (plant_entity_id, time DESC);

-- Hourly Continuous Aggregate (for 24h & 7d charts)
CREATE MATERIALIZED VIEW IF NOT EXISTS plant_metrics_hourly
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 hour', time) AS bucket,
    plant_entity_id,
    LAST(species, time) AS species,
    AVG(soil_moisture) AS avg_soil_moisture,
    MIN(soil_moisture) AS min_soil_moisture,
    MAX(soil_moisture) AS max_soil_moisture,
    AVG(temperature) AS avg_temperature,
    MIN(temperature) AS min_temperature,
    MAX(temperature) AS max_temperature,
    AVG(air_humidity) AS avg_air_humidity,
    AVG(illuminance) AS avg_illuminance,
    MAX(dli) AS max_dli,
    AVG(vapour_pressure_deficit) AS avg_vpd,
    LAST(battery, time) AS last_battery,
    COUNT(*) AS total_samples,
    COUNT(*) FILTER (WHERE plant_state = 'ok') AS ok_samples,
    COUNT(*) FILTER (WHERE moisture_status = 'low') AS low_moisture_samples
FROM plant_metrics
GROUP BY bucket, plant_entity_id
WITH NO DATA;

SELECT add_continuous_aggregate_policy('plant_metrics_hourly',
    start_offset => INTERVAL '3 hours',
    end_offset   => INTERVAL '5 minutes',
    schedule_interval => INTERVAL '15 minutes',
    if_not_exists => TRUE);

-- Daily Continuous Aggregate (for 30d charts & Daily Health Streaks)
CREATE MATERIALIZED VIEW IF NOT EXISTS plant_metrics_daily
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 day', time) AS day_bucket,
    plant_entity_id,
    LAST(species, time) AS species,
    AVG(soil_moisture) AS avg_soil_moisture,
    MIN(soil_moisture) AS min_soil_moisture,
    MAX(soil_moisture) AS max_soil_moisture,
    AVG(temperature) AS avg_temperature,
    MIN(temperature) AS min_temperature,
    MAX(temperature) AS max_temperature,
    AVG(air_humidity) AS avg_air_humidity,
    AVG(illuminance) AS avg_illuminance,
    MAX(dli) AS daily_dli,
    AVG(vapour_pressure_deficit) AS avg_vpd,
    MIN(battery) AS min_battery,
    COUNT(*) AS total_samples,
    COUNT(*) FILTER (WHERE plant_state = 'ok') AS ok_samples,
    COUNT(*) FILTER (WHERE moisture_status != 'ok') AS moisture_violation_samples
FROM plant_metrics
GROUP BY day_bucket, plant_entity_id
WITH NO DATA;

SELECT add_continuous_aggregate_policy('plant_metrics_daily',
    start_offset => INTERVAL '3 days',
    end_offset   => INTERVAL '1 hour',
    schedule_interval => INTERVAL '1 hour',
    if_not_exists => TRUE);

-- Compression & Retention Policies
ALTER TABLE plant_metrics SET (
    timescaledb.compress,
    timescaledb.compress_segmentby = 'plant_entity_id',
    timescaledb.compress_orderby = 'time DESC'
);

SELECT add_compression_policy('plant_metrics', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_retention_policy('plant_metrics', INTERVAL '90 days', if_not_exists => TRUE);
EOF"

echo "[6/7] Writing Telegraf configuration..."
pct exec "$CTID" -- bash -c "cat << 'EOF' > /opt/terrapulse/telegraf/telegraf.conf
[agent]
  interval = \"10s\"
  flush_interval = \"10s\"

[[inputs.mqtt_consumer]]
  servers = [\"tcp://mosquitto:1883\"]
  topics = [\"terrapulse/sensors/+\"]
  qos = 1
  data_format = \"json_v2\"

  [[inputs.mqtt_consumer.json_v2]]
    measurement_name = \"plant_metrics\"
    [[inputs.mqtt_consumer.json_v2.tag]]
      path = \"plant_entity_id\"
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"species\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"plant_state\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"soil_moisture\"
      type = \"float\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"temperature\"
      type = \"float\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"air_humidity\"
      type = \"float\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"illuminance\"
      type = \"float\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"dli\"
      type = \"float\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"vapour_pressure_deficit\"
      type = \"float\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"moisture_status\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"temperature_status\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"illuminance_status\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"humidity_status\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"dli_status\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"vpd_status\"
      type = \"string\"
      optional = true
    [[inputs.mqtt_consumer.json_v2.field]]
      path = \"battery\"
      type = \"float\"
      optional = true

[[outputs.postgresql]]
  connection = \"host=timescaledb user=postgres password=${DB_PASS} dbname=terrapulse sslmode=disable\"
  tags_as_foreign_keys = false
EOF"

echo "[7/7] Writing docker-compose.yml and starting containers..."
pct exec "$CTID" -- bash -c "cat << 'EOF' > /opt/terrapulse/docker-compose.yml
services:
  mosquitto:
    image: eclipse-mosquitto:2
    container_name: terrapulse-mosquitto
    restart: unless-stopped
    ports:
      - \"1883:1883\"
    volumes:
      - ./mosquitto/config:/mosquitto/config
      - ./mosquitto/data:/mosquitto/data
      - ./mosquitto/log:/mosquitto/log

  timescaledb:
    image: timescale/timescaledb:latest-pg16
    container_name: terrapulse-timescaledb
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASS}
      POSTGRES_DB: terrapulse
    ports:
      - \"5432:5432\"
    volumes:
      - timescale_data:/var/lib/postgresql/data
      - ./init-db:/docker-entrypoint-initdb.d
    healthcheck:
      test: [\"CMD-SHELL\", \"pg_isready -U postgres -d terrapulse\"]
      interval: 5s
      timeout: 5s
      retries: 10

  telegraf:
    image: telegraf:1.32
    container_name: terrapulse-telegraf
    restart: unless-stopped
    depends_on:
      mosquitto:
        condition: service_started
      timescaledb:
        condition: service_healthy
    volumes:
      - ./telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro

volumes:
  timescale_data:
EOF
cd /opt/terrapulse && docker compose up -d
"

echo "=============================================================================="
echo "TerraPulse IoT Stack deployed successfully in LXC $CTID!"
echo -n "LXC IP Address: "
pct exec "$CTID" -- hostname -I
echo "=============================================================================="

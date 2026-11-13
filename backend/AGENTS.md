# TerraPulse FastAPI Backend — Agent Guide

This directory (`backend/`) contains the **FastAPI** Python REST API that queries **TimescaleDB** and serves telemetry, continuous aggregates, and streak data to the Flutter app.

---

## 1. Tech Stack & Planned Layout

- **Framework:** FastAPI + Uvicorn + Pydantic v2 (`pydantic-settings`)
- **Database Driver:** `psycopg` v3 (PostgreSQL / TimescaleDB)
- **Containerization:** `Dockerfile` (port `8000`), intended to run alongside `timescaledb` on the Docker network in `../infra/proxmox_create_terrapulse_lxc.sh` and exposed externally via Cloudflare Tunnel (`api.lukadev.de` → `http://fastapi:8000`).

### Recommended Directory Structure
```text
backend/
├── app/
│   ├── main.py              # FastAPI app, CORS, router registration, /health
│   ├── core/
│   │   └── config.py        # Pydantic Settings (DATABASE_URL, CORS_ORIGINS)
│   ├── db/
│   │   └── session.py       # psycopg connection pool / dependency
│   ├── schemas/
│   │   └── plant.py         # Pydantic response models (LatestMetric, HistoryPoint, StreakSummary)
│   ├── services/
│   │   └── telemetry.py     # Parameterized SQL queries against plant_metrics & aggregates
│   └── api/
│       └── routes/
│           └── plants.py    # /plants/latest, /plants/{id}/history, /plants/{id}/streaks
├── tests/
│   └── test_health.py
├── Dockerfile
├── pyproject.toml
├── requirements.txt
└── .env.example
```

---

## 2. TimescaleDB Schema Contract

The database schema is initialized by `../infra/proxmox_create_terrapulse_lxc.sh` (`01_init.sql`). **Do not invent different column names**; match these exact identifiers:

### Hypertable: `plant_metrics` (7-day chunks, indexed on `(plant_entity_id, time DESC)`)
- `time` (`TIMESTAMPTZ`)
- `plant_entity_id` (`TEXT`)
- `species` (`TEXT`)
- `plant_state` (`TEXT`)
- `soil_moisture` (`DOUBLE PRECISION`)
- `temperature` (`DOUBLE PRECISION`)
- `air_humidity` (`DOUBLE PRECISION`)
- `illuminance` (`DOUBLE PRECISION`)
- `dli` (`DOUBLE PRECISION`)
- `vapour_pressure_deficit` (`DOUBLE PRECISION`)
- `moisture_status`, `temperature_status`, `illuminance_status`, `humidity_status`, `dli_status`, `vpd_status` (`TEXT`)
- `battery` (`DOUBLE PRECISION`)

### Continuous Aggregates
- `plant_metrics_hourly` (`bucket`, `plant_entity_id`, `species`, `avg_soil_moisture`, `min_soil_moisture`, `max_soil_moisture`, `avg_temperature`, `min_temperature`, `max_temperature`, `avg_air_humidity`, `avg_illuminance`, `max_dli`, `avg_vpd`, `last_battery`, `total_samples`, `ok_samples`, `low_moisture_samples`) — use for `24h` and `7d` history charts.
- `plant_metrics_daily` (`day_bucket`, `plant_entity_id`, `species`, `avg_soil_moisture`, `min_soil_moisture`, `max_soil_moisture`, `avg_temperature`, `min_temperature`, `max_temperature`, `avg_air_humidity`, `avg_illuminance`, `daily_dli`, `avg_vpd`, `min_battery`, `total_samples`, `ok_samples`, `moisture_violation_samples`) — use for `30d` history charts and **Daily Health Streaks**.

---

## 3. Planned REST Endpoints

1. `GET /health` → `{"status": "ok", "service": "terrapulse-api"}`
2. `GET /plants/latest?plant_ids=zlati_potos,monstera_01`
   - Uses `SELECT DISTINCT ON (plant_entity_id) ... FROM plant_metrics WHERE plant_entity_id = ANY(%s) ORDER BY plant_entity_id, time DESC`
3. `GET /plants/{plant_entity_id}/history?range=24h|7d|30d`
   - `24h` / `7d`: queries `plant_metrics_hourly`
   - `30d`: queries `plant_metrics_daily`
4. `GET /plants/{plant_entity_id}/streaks`
   - Queries `plant_metrics_daily` to compute consecutive days where `ok_samples` / `moisture_violation_samples` meet healthy criteria.

---

## 4. Local Development & Testing

Run from `backend/`:
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
pytest
uvicorn app.main:app --reload --port 8000
```

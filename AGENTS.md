# TerraPulse — Agent & Developer Guide

> **Course:** Razvoj vseprisotnih informacijskih rešitev (RVIR · 2026/2027), FERI, Univerza v Mariboru  
> **Team:** Luka Grobelnik (Vodja projekta), Jan Mrkonjič, Matija Gusel

This repository contains the **TerraPulse** smart IoT plant monitoring system. Use this guide (and the scoped `AGENTS.md` files inside `app/` and `backend/`) when designing, planning, or implementing features.

---

## 1. Repository Structure

| Path | Purpose | Agent Guide |
| --- | --- | --- |
| `app/` | Flutter mobile application (Android) | [app/AGENTS.md](app/AGENTS.md) |
| `backend/` | FastAPI Python REST backend reading TimescaleDB | [backend/AGENTS.md](backend/AGENTS.md) |
| `infra/` | Proxmox LXC provisioning & Docker stack (`Mosquitto`, `Telegraf`, `TimescaleDB`, `cloudflared`) | [infra/proxmox_create_terrapulse_lxc.sh](infra/proxmox_create_terrapulse_lxc.sh) |
| `dokumentacija/` | Academic specs, use cases, Draw.io diagram, Stitch design tokens & screen mockups | [dokumentacija/01_opis_projekta_in_funkcionalnosti.md](dokumentacija/01_opis_projekta_in_funkcionalnosti.md) |

---

## 2. End-to-End Architecture & Data Flow

```text
[IoT Sensor (SOILSENS-V5W / Node-RED)]
        │  MQTT JSON (topic: terrapulse/sensors/<plant_entity_id>)
        ▼
[Eclipse Mosquitto]  (TCP 1883 LAN / WSS 443 via mqtt.lukadev.de)
        │
        ▼
[InfluxData Telegraf] (inputs.mqtt_consumer -> json_v2 -> outputs.postgresql)
        │
        ▼
[TimescaleDB]         (hypertable: plant_metrics + hourly/daily continuous aggregates)
        │
        ▼
[FastAPI Backend]     (REST API: /plants/latest, /plants/{id}/history, /plants/{id}/streaks)
        │
        ▼
[Flutter Mobile App]  (Hive offline-first local storage + OpenPlantbook API + Firebase Auth)
```

---

## 3. Shared Data Contract (MQTT -> Telegraf -> TimescaleDB)

Sensors or Node-RED flows publish JSON payloads to `terrapulse/sensors/<plant_entity_id>` with QoS `1`:

```json
{
  "plant_entity_id": "zlati_potos",
  "species": "Epipremnum aureum",
  "plant_state": "ok",
  "soil_moisture": 42.5,
  "temperature": 23.1,
  "air_humidity": 58.0,
  "illuminance": 850.0,
  "dli": 12.4,
  "vapour_pressure_deficit": 1.18,
  "battery": 95.0,
  "moisture_status": "ok",
  "temperature_status": "ok",
  "illuminance_status": "ok",
  "humidity_status": "ok",
  "dli_status": "ok",
  "vpd_status": "ok"
}
```

- `plant_entity_id` is stored as a tag/indexed column and acts as the primary join key between `TimescaleDB` (`plant_metrics`) and `Hive` (`PlantProfileBox`).
- **Do not** write directly from sensors or the Flutter app into TimescaleDB. Ingestion is strictly `MQTT -> Telegraf -> TimescaleDB`; reads go strictly through `FastAPI`.

---

## 4. Live Infrastructure Reference

- **Host:** Proxmox LXC `210` (`terrapulse-iot`), LAN IP `192.168.1.105`
- **External Access (Cloudflare Tunnel):**
  - `mqtt.lukadev.de` (Port `443`, `wss://`) → `http://mosquitto:9001` (live & verified)
  - `api.lukadev.de` (Port `443`, `https://`) → `http://fastapi:8000` (planned for FastAPI container)

---

## 5. Key Documentation References

- **Functional Spec:** [dokumentacija/01_opis_projekta_in_funkcionalnosti.md](dokumentacija/01_opis_projekta_in_funkcionalnosti.md)
- **Use Cases & Scenarios:** [dokumentacija/02_primeri_uporabe_in_scenariji.md](dokumentacija/02_primeri_uporabe_in_scenariji.md)
- **Screens, Mockups & Navigation:** [dokumentacija/03_mockupi_in_navigacija.md](dokumentacija/03_mockupi_in_navigacija.md)
- **Data Model & TimescaleDB SQL:** [dokumentacija/04_podatkovni_model_in_arhitektura.md](dokumentacija/04_podatkovni_model_in_arhitektura.md)
- **UI Design System Tokens:** [dokumentacija/stitch_export/DESIGN.md](dokumentacija/stitch_export/DESIGN.md)

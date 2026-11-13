# TerraPulse Flutter App — Agent Guide

This directory (`app/`) contains the **Flutter** Android mobile application for TerraPulse (Android-only target).

---

## 1. Design System ("Botanical Precision")

Before creating any theme, colors, typography, or widgets, read the full design specification in:
- `../dokumentacija/stitch_export/DESIGN.md`
- Visual mockups in `../dokumentacija/images/stitch/` and `../dokumentacija/03_mockupi_in_navigacija.md`

### Key Design Tokens
- **Canvas / Background:** `#F9F9FF` (or `#F6F9F7` soft canvas)
- **Primary Botanical Green:** `#006037` / `#1E7A4C`
- **Secondary Deep Green:** `#2E6A41` / `#14532D`
- **Tertiary Alert Amber:** `#834100` / `#E67E22` (moisture warnings, low battery, pairing timeouts)
- **Error:** `#BA1A1A`
- **Neutral Ink:** `#111C2D` / `#1E293B`
- **Typography:** `Plus Jakarta Sans` (headings/display) + `Inter` (body/labels)
- **Aesthetic Principle:** Minimalist, airy, uncrowded UI. Avoid data overload; surface only actionable status and clean charts.

---

## 2. Core Screens & Navigation Flow

1. **Empty Garden (`/` when no plants exist):** Welcome illustration + single primary CTA `+ Add Your First Plant`.
2. **3D Ambient Virtual Garden (`Home` tab when plants exist):** Ambient 3D/interactive garden reflecting real-time `plant_state`, `moisture_status` (water drop indicator), and `illuminance`, plus compact `Streak` badge.
3. **My Plants (`Plants` tab):** Clean list of user plants with health score % (e.g., `98% Healthy` or `Needs Water 18%`). Tapping opens Plant Details.
4. **Plant Details (`/plants/:id`):** Current telemetry (`soil_moisture`, `temperature`, `air_humidity`, `illuminance`/`dli`, `battery`) vs. optimal OpenPlantbook thresholds + interactive `24h` / `7d` / `30d` history charts.
5. **Add Sensor & Plant Wizard (`/add-plant`):**
   - Step 1: Visual guide to press `CAL` + `TRG` (>2s) on `SOILSENS-V5W` and connect to sensor Wi-Fi AP (`192.168.4.1`).
   - Step 2: User enters home Wi-Fi SSID/password; app auto-provisions MQTT broker (`mqtt.lukadev.de`), topic, and generated `plant_entity_id` in the background.
   - Step 3: Search species via **OpenPlantbook API**, set custom name and placement zone (`Living Room`, `Balcony`, `Office`).
6. **Settings (`/settings`):** Garden streak stats, local **Hive** profile status, optional **Firebase Auth** (`Sign In / Sync`, `Log Out`, `Delete Account`), and push notification toggles.

---

## 3. Recommended Code Architecture

Organize `lib/` using a clean layered feature-first structure:

```text
lib/
├── main.dart
├── app.dart                     # MaterialApp / GoRouter + BotanicalPrecisionTheme
├── core/
│   ├── theme/                   # ColorScheme, TextTheme (Plus Jakarta Sans & Inter)
│   ├── network/                 # HTTP client for FastAPI & OpenPlantbook API
│   └── constants/               # API base URLs (api.lukadev.de), MQTT config
├── data/
│   ├── local/                   # Hive initialization & type adapters
│   │   ├── local_user_profile_box.dart
│   │   ├── plant_profile_box.dart
│   │   └── cached_plant_state_box.dart
│   ├── models/                  # Freezed / JSON serializable DTOs
│   └── repositories/            # PlantRepository, TelemetryRepository, AuthRepository
└── features/
    ├── garden/                  # Empty Garden + 3D Ambient Virtual Garden
    ├── plants/                  # My Plants list + Plant Details (24h/7d/30d charts)
    ├── onboarding_wizard/       # 3-step Add Sensor & Plant Wizard
    └── settings/                # Streaks, Notifications, Firebase Auth
```

### Offline-First Hive Boxes (see `../dokumentacija/04_podatkovni_model_in_arhitektura.md` §4.7)
- `LocalUserProfileBox`: `localUserId`, `firebaseUid`, `displayName`, `currentGardenStreak`, `longestGardenStreak`, `lastStreakEvaluationDate`, `notificationsEnabled`, `isCloudSynced`
- `PlantProfileBox`: `plantEntityId`, `customName`, `placementZone`, `speciesPid`, `imageUrl`, `avatarStyleId`, optimal min/max thresholds (`minSoilMoist`, `maxSoilMoist`, `minTemp`, `maxTemp`, `minEnvHumid`, `maxEnvHumid`, `minLightLux`, `maxLightLux`, `minDli`, `maxDli`)
- `CachedPlantStateBox`: `plantEntityId`, `lastUpdated`, `plantState`, `soilMoisture`, `temperature`, `airHumidity`, `illuminance`, `dli`, `vpd`, `battery`, `healthScorePercent`

---

## 4. Verification Commands

Run from `app/`:
```bash
flutter pub get
flutter analyze
flutter test
```

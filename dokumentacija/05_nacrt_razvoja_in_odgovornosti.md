# 5. Načrt razvoja, mejniki in razdelitev odgovornosti

> **Predmet:** Razvoj vseprisotnih informacijskih rešitev (RVIR · 2026/2027), FERI, Univerza v Mariboru  
> **Projekt:** TerraPulse – Pametni sistem za spremljanje rasti in zdravja rastlin  
> **Člani ekipe:**  
> * **Luka Grobelnik (Vodja projekta)**  
> * **Jan Mrkonjič**  
> * **Matija Gusel**  

---

## 5.1 Način sodelovanja in razdelitev odgovornosti

Ekipa deluje agilno v 3-članski zasedbi po načelu **tesnega sodelovanja in pregledov kode (*Pull Request Reviews*)**, pri čemer so primarna področja odgovornosti razdeljena po jasnih arhitekturnih slojih glede na močna področja članov ekipe — tako ima vsak član približno tretjino obsega dela z minimalnim tveganjem za konflikte v Gitu:

| Član ekipe | Vloga | Primarna področja odgovornosti | Sekundarna podpora / sodelovanje |
| :--- | :--- | :--- | :--- |
| **Luka Grobelnik** | Vodja projekta, Backend & IoT / DevOps | Vodenje projekta, celoten zaledni sistem **FastAPI** + poizvedbe in agregati nad **TimescaleDB** (`api.lukadev.de`, `/plants/latest`, `/history`, `/streaks`, preverjanje senzorja), enotski testi (`pytest`), Proxmox LXC infrastruktura (`Mosquitto`, `Telegraf`, `TimescaleDB`, Cloudflare Tunnel), CI/CD (GitHub Actions), strojni protokol senzorja `SOILSENS-V5W` | Pregledi kode na frontendu, pomoč pri Wi-Fi/MQTT komunikaciji v čarovniku, integracijsko testiranje |
| **Jan Mrkonjič** | Frontend (Flutter UI/UX, Grafi & 3D vrt) | Oblikovni sistem *Botanical Precision* in navigacija, začetni zaslon (*Empty Garden*) in **3D Ambientni virtualni vrt**, seznam rastlin (*My Plants*), zaslon **Podrobnosti rastline** z interaktivnimi zgodovinskimi grafi (`24h` / `7d` / `30d`), Flutter Widget testi | Sodelovanje pri povezavi UI s podatkovnim slojem (Hive/API), pregledi kode in tehnična dokumentacija |
| **Matija Gusel** | Firebase, Podatkovni sloj (Hive), Integracije & Čarovnik | **Firebase Authentication** (prijava, oblačna sinhronizacija, odjava, izbris računa), **potisna obvestila** in zaslon *Settings*, lokalna shramba **Hive** (*offline-first* profil, rastline, predpomnilnik), HTTP odjemalec za zaledni FastAPI in **OpenPlantbook API**, 3-stopenjski **čarovnik za dodajanje rastline in senzorja** | Povezava lokalnega/oblačnega sloja s frontend zasloni, pregledi kode in celovito testiranje |

> **Opomba k sodelovanju:** Medtem ko ima vsaka naloga na GitHubu natančno določenega primarnega nosilca (`Assignee`), vsi člani ekipe sodelujejo pri pregledu *Pull Requestov*, integraciji med sloji in zaključnem testiranju celotnega sistema.

---

## 5.2 Časovni načrt razvoja (Faze in mejniki)

Razvoj sistema **TerraPulse** je razdeljen v štiri zaporedne mejnike (*Milestones*), usklajene s študijskim koledarjem predmeta RVIR (zimski semester 2026/2027):

| Mejnik | Okvirno obdobje | Glavni cilji in rezultati (*Deliverables*) | Povezani GitHub Issues | Status |
| :--- | :--- | :--- | :--- | :--- |
| **M1: Zasnova, prototip, infrastruktura & CI** | November 2026 | Projektna zasnova, DPU in scenariji, 6 mockupov (Google Stitch), podatkovni model TimescaleDB + Hive, Proxmox LXC (`Mosquitto` + `Telegraf` + `TimescaleDB`), začetni Flutter in FastAPI skelet, delujoč GitHub Actions CI. | `#1`, `#2`, `#3` | ✅ Zaključeno |
| **M2: Zaledni REST API & temelj aplikacije** | Konec novembra – sredina decembra 2026 | Povezava FastAPI na TimescaleDB in objava prek `api.lukadev.de`, končne točke `/plants/latest`, `/history`, `/streaks`, preverjanje aktivnosti senzorja; na Flutterju tema *Botanical Precision*, navigacija, lokalna baza Hive in API odjemalec. | `#4`, `#5`, `#6`, `#7`, `#8`, `#9`, `#10`, `#11` | 🔄 V načrtu |
| **M3: Ključni zasloni & čarovnik za senzor** | Sredina decembra 2026 – začetek januarja 2027 | Seznam rastlin (*My Plants*), podrobnosti rastline z interaktivnimi grafi (`24h` / `7d` / `30d`) in OpenPlantbook pragovi, 3-stopenjski čarovnik za samodejno konfiguracijo senzorja `SOILSENS-V5W`. | `#13`, `#14`, `#15` | ⏳ Načrtovano |
| **M4: 3D vrt, obvestila, Firebase & finalizacija** | Januar 2027 | Začetni zaslon (*Empty Garden*) in 3D ambientni virtualni vrt z dnevnimi nizi (*Streaks*), nastavitve s potisnimi obvestili in opcijsko Firebase Auth sinhronizacijo, celovito testiranje (end-to-end), končno poročilo in zagovor. | `#12`, `#16` | ⏳ Načrtovano |

---

## 5.3 Organizacija dela na GitHubu

### 1. Sistem oznak (*Labels*) in prioritet
Vsaka naloga (*GitHub Issue*) nosi vsaj eno **področno oznako** in eno **oznako prioritete**:
* **Področne oznake:** `iot-infra`, `backend`, `frontend`, `documentation`.
* **Oznake prioritet:**
  * `priority: high` — kritične naloge za delovanje jedrnega podatkovnega toka (MVP) ali popravki CI/CD.
  * `priority: medium` — pomembne uporabniške funkcionalnosti (grafi, čarovnik, 3D vrt, igrifikacija).
  * `priority: low` — nadgradnje, opcijska sinhronizacija (Firebase Auth) in vizualne dodelave.

### 2. Potek dela z vejami (*Git Workflow*) in CI/CD
1. Glavna veja `main` je namenjena preverjeni, delujoči kodi; nove funkcionalnosti se razvijajo na kratkoživih vejah (`feature/<issue-id>-kratek-opis` ali `fix/...`).
2. Pred združitvijo v `main` se odpre **Pull Request**, ki se poveže z ustreznim Issue-jem (`Closes #<id>`).
3. Združitev se izvede šele, ko uspešno zaključita samodejna preverjanja **GitHub Actions** (`Backend CI/CD` – `pytest`; `Flutter CI` – `flutter analyze`, `flutter test`, Android APK build) in kodo pregleda vsaj en drug član ekipe.

### 3. Pregled začetnih GitHub Issues, prioritet in dodelitve odgovornosti

| Issue | Naslov naloge | Področje | Prioriteta | Mejnik | Odgovorni član | Status |
| :-: | :--- | :--- | :--- | :-: | :--- | :-: |
| `#1` | IoT & Infrastruktura – Proxmox LXC, Mosquitto, Telegraf & TimescaleDB | `iot-infra` | `priority: high` | M1 | Luka Grobelnik | ✅ Zaprto |
| `#2` | IoT & Zajem podatkov – Node-RED / MQTT tok | `iot-infra` | `priority: high` | M1 | Luka Grobelnik | ✅ Zaprto |
| `#3` | Začetna zasnova projektov in CI/CD (GitHub Actions) | `iot-infra` | `priority: high` | M1 | Luka Grobelnik | ✅ Zaprto |
| `#4` | Zaledna povezava na TimescaleDB in objava API-ja (`api.lukadev.de`) | `backend` | `priority: high` | M2 | Luka Grobelnik | 🟢 Odprto |
| `#5` | Zadnje meritve in status rastlin (`GET /plants/latest`) | `backend` | `priority: high` | M2 | Luka Grobelnik | 🟢 Odprto |
| `#6` | Zgodovinski grafi in agregati (`GET /plants/{id}/history`) | `backend` | `priority: high` | M2 | Luka Grobelnik | 🟢 Odprto |
| `#7` | Sistem nizov (*Streaks*) in ocena zdravja (`GET /plants/{id}/streaks`) | `backend` | `priority: medium` | M2 | Luka Grobelnik | 🟢 Odprto |
| `#8` | Preverjanje aktivnosti senzorja in dodajanje rastlin | `backend` | `priority: medium` | M2 | Luka Grobelnik | 🟢 Odprto |
| `#9` | Dizajn sistem (*Botanical Precision*) in navigacija | `frontend` | `priority: high` | M2 | Jan Mrkonjič | 🟢 Odprto |
| `#10` | Lokalna shramba (*offline-first* Hive) | `frontend` | `priority: high` | M2 | Matija Gusel | 🟢 Odprto |
| `#11` | Povezava z zalednim API-jem in OpenPlantbook API | `frontend` | `priority: high` | M2 | Matija Gusel | 🟢 Odprto |
| `#12` | Začetni zaslon (*Empty Garden*) in 3D Ambientni virtualni vrt | `frontend` | `priority: medium` | M4 | Jan Mrkonjič | 🟢 Odprto |
| `#13` | Seznam rastlin (*My Plants*) | `frontend` | `priority: high` | M3 | Jan Mrkonjič | 🟢 Odprto |
| `#14` | Podrobnosti rastline in zgodovinski grafi (`24h` / `7d` / `30d`) | `frontend` | `priority: high` | M3 | Jan Mrkonjič | 🟢 Odprto |
| `#15` | Čarovnik za dodajanje novih rastlin in senzorja (`SOILSENS-V5W`) | `frontend` | `priority: medium` | M3 | Matija Gusel | 🟢 Odprto |
| `#16` | Nastavitve, potisna obvestila in Firebase Auth | `frontend` | `priority: low` | M4 | Matija Gusel | 🟢 Odprto |

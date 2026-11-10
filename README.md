# Predlog ideje projektne naloge

## 1. Naslov projekta
**TerraPulse – Pametni sistem za spremljanje rasti in zdravja rastlin**

## 2. Člani ekipe
* [Ime in priimek 1] (vodja ekipe)
* [Ime in priimek 2]
* [Ime in priimek 3]

## 3. Opis projekta
Mobilna aplikacija TerraPulse uporabnikom omogoča celovito in preprosto spremljanje rasti ter stanja sobnih rastlin s pomočjo brezžičnih senzorjev (kot je [SOILSENS-V5W](https://github.com/PricelessToolkit/SOILSENS-V5W) ali poljuben drug senzor, ki pošilja standardizirane podatke), ki merijo vlažnost in temperaturo prsti, temperaturo in vlažnost zraka, osvetljenost okolice ter stanje baterije. Rešuje pogost problem nepravilne nege rastlin (prekomerno ali preredko zalivanje ter neprimerni mikroklimatski pogoji). Namenjena je ljubiteljem rastlin, saj z vodenim čarovnikom v aplikaciji, ki v ozadju samodejno nastavi senzor, zajemom podatkov prek MQTT brokerja **Mosquitto** in agenta **Telegraf** v **TimescaleDB**, podatkovno bazo rastlin **OpenPlantbook**, 3D ambientnim virtualnim vrtom in igrifikacijo poenostavi skrb za rastline ter preprečuje njihovo propadanje.

## 4. Glavne funkcionalnosti
* **3D Ambientni virtualni vrt in seznam rastlin:** pregleden 3D prikaz vrta z ambientom, ki odraža stanje rastlin (ali začetni zaslon s pozivom k dodajanju prve rastline, če je vrt še prazen), ter čist seznam vseh rastlin s hitrimi statusi zdravja.
* **Voden čarovnik za dodajanje rastline in samodejna konfiguracija senzorja:** vodniček uporabnika z ilustracijami vodi skozi izbiro Wi-Fi točke senzorja in vnos domačega Wi-Fi gesla, medtem ko aplikacija v ozadju sama ustvari konfiguracijo (MQTT broker, nastavitve in enolični ID), shrani rastlino ter omogoči izbiro vrste iz OpenPlantbooka in poimenovanje.
* **Podrobnosti rastline, optimalne meje in zgodovinski grafi (24h / 7d / 30d):** prikaz trenutnih meritev v primerjavi z optimalnimi vrednostmi iz baze OpenPlantbook ter interaktivni časovni grafi iz TimescaleDB neprekinjenih agregatov.
* **Standardiziran MQTT zajem (Mosquitto + Telegraf → TimescaleDB):** poljuben senzor pošilja standardizirane podatke na Mosquitto MQTT broker, od koder jih Telegraf samodejno zapisuje neposredno v časovno-serijsko bazo TimescaleDB.
* **Pametna potisna obvestila in sistem nizov (angl. streaks):** obveščanje uporabnika ob nizki vlažnosti prsti ali prazni bateriji ter beleženje zaporednih dni optimalnega zdravja vrta.
* **Lokalni profil in upravljanje računa (Hive + Firebase Auth):** takojšnja uporaba z lokalnim profilom na napravi ter možnost prijave/sinhronizacije prek Firebase Auth, odjave in izbrisa računa.

## 5. Predvidene tehnologije
* **Mobilno ogrodje, 3D/2D animacije in lokalna baza:** Flutter, Rive/Lottie/3D (interaktivni virtualni vrt) ter lokalna shramba Hive (shranjevanje podatkov o rastlinah, nizih in lokalnem profilu na napravi).
* **IoT komunikacija in zajem podatkov:** protokol MQTT (**Eclipse Mosquitto** broker) in **InfluxData Telegraf** (neposreden zapis standardiziranih MQTT sporočil v TimescaleDB).
* **Časovno-serijska podatkovna baza:** **TimescaleDB** (PostgreSQL razširitev za shranjevanje zgodovine meritev, neprekinjene agregate in stolpično kompresijo).
* **Zaledni sistem (Backend):** **FastAPI** (Python REST API za branje podatkov iz TimescaleDB in komunikacijo z mobilno aplikacijo).
* **Avtentikacija:** **Firebase Authentication** (opcijska prijava za sinhronizacijo, odjavo in izbris računa).
* **Zunanje spletne storitve:** **OpenPlantbook API** (pridobivanje podatkov in optimalnih pogojev za posamezne vrste rastlin).
* **Strojna oprema (senzor):** [SOILSENS-V5W](https://github.com/PricelessToolkit/SOILSENS-V5W) (ali poljuben senzor s standardiziranim MQTT JSON izhodom).
* **Verzioniranje in CI/CD:** GitHub in GitHub Actions.

---

## 6. Projektna dokumentacija (Mejniki in arhitektura)
Podrobna dokumentacija zasnove, primerov uporabe, mockupov in podatkovnega modela (Mosquitto + Telegraf + TimescaleDB + Hive) je na voljo v mapi `docs/` ter v zbirnem Word dokumentu:

* 📄 **[Zbirni dokument zasnove (Word .docx)](Dokumentacija_zasnove_TerraPulse_v2.docx)**
* 📐 **[Izmenljiv Draw.io diagram primerov uporabe (.drawio)](docs/TerraPulse_DPU.drawio)**
* 📘 **[1. Podrobnejši opis projekta in glavnih funkcionalnosti](docs/01_opis_projekta_in_funkcionalnosti.md)**
* 📗 **[2. Diagram primerov uporabe in ključni uporabniški scenariji](docs/02_primeri_uporabe_in_scenariji.md)**
* 📙 **[3. Mockupi najpomembnejših zaslonov in predvidena navigacija](docs/03_mockupi_in_navigacija.md)**
* 📕 **[4. Začetni podatkovni model, TimescaleDB optimizacija in arhitektura](docs/04_podatkovni_model_in_arhitektura.md)**
* 🐧 **[Proxmox LXC skripta za namestitev (Mosquitto + Telegraf + TimescaleDB)](infra/proxmox_create_terrapulse_lxc.sh)**


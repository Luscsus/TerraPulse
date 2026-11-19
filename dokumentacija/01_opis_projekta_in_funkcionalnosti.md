# 1. Podrobnejši opis projekta in glavnih funkcionalnosti

> **Predmet:** Razvoj vseprisotnih informacijskih rešitev (RVIR · 2026/2027), FERI, Univerza v Mariboru  
> **Projekt:** TerraPulse – Pametni sistem za spremljanje rasti in zdravja rastlin  
> **Člani ekipe:**  
> * **Luka Grobelnik (Vodja projekta)**  
> * **Jan Mrkonjič**  
> * **Matija Gusel**  

---

## 1.1 Opredelitev problema in namen projekta
Skrb za sobne in balkonske rastline pogosto temelji na ugibanju, kar vodi do dveh najpogostejših vzrokov za propad rastlin: **prekomernega ali preredkega zalivanja** ter **neustreznih mikroklimatskih pogojev** (premajhna osvetljenost oz. nizek dnevni svetlobni integral – DLI, neustrezna temperatura ter neugoden primanjkljaj parnega tlaka – VPD).

Projekt **TerraPulse** rešuje ta problem s strojno neodvisno (*hardware-agnostic*) IoT arhitekturo: poljuben senzor za rastline (kot je referenčni brezžični senzor [SOILSENS-V5W](https://github.com/PricelessToolkit/SOILSENS-V5W) na osnovi ESP32-C3) pošilja **standardizirane podatke** na **Mosquitto MQTT Broker**, od koder jih agent **Telegraf** samodejno zapisuje v časovno-serijsko podatkovno bazo **TimescaleDB**. Zaledni sistem **FastAPI** in večplatformska mobilna aplikacija v ogrodju **Flutter** te meritve pretvorita v preprost, pregleden 3D ambientni vrt, seznam rastlin, zgodovinske grafe, pametne opomnike in dnevne nize (*streaks*).

## 1.2 Ciljna skupina
* **Ljubitelji sobnih rastlin in urbani vrtnarji**, ki želijo natančen, a vizualno preprost vpogled v potrebe svojih rastlin brez prenasičenosti z nepotrebnimi tehničnimi podatki.
* **Začetniki pri negi rastlin**, ki potrebujejo popolnoma avtomatizirano namestitev senzorja prek vodenega čarovnika v aplikaciji, jasna potisna obvestila za zalivanje in dodatno motivacijo prek igrifikacije.
* **IoT navdušenci**, ki želijo v sistem vključiti senzorje `SOILSENS-V5W` ali lastne senzorje, ki pošiljajo standardiziran MQTT JSON paket.

---

## 1.3 Podroben opis glavnih funkcionalnosti

### F1: Začetni zaslon (Prazen vrt) in 3D Ambientni virtualni vrt (*Virtual Garden*)
* **Namen:** Čist in pregleden vstopni zaslon, prilagojen stanju uporabnika, brez prenasičenosti s podatki.
* **Delovanje:**
  * **Če uporabnik še nima dodane rastline (*Empty Garden*):** Prikaže se preprost pozdravni zaslon z ilustracijo praznega lončka in gumbom **`+ Add Your First Plant`**, ki uporabnika neposredno pelje v vodniček za dodajanje rastline.
  * **Če uporabnik že ima rastline (*3D Ambient Virtual Garden*):** Prikaže se 3D pogled vrta s posameznimi rastlinami in ambientom prostora, ki v realnem času odraža stanje rastlin (`plant_state`, `moisture_status` z lebdečo kapljico ob žeji in `illuminance`), skupaj s kompaktnim prikazom dnevnega niza (*Streak*).

### F2: Vodeno dodajanje rastline in samodejna konfiguracija senzorja v ozadju (*Add Plant Wizard*)
* **Namen:** Popolnoma poenostaviti priklop novega senzorja brez ročnega nastavljanja MQTT strežnika ali odpiranja spletnega brskalnika.
* **Uporabniški tok čarovnika:**
  1. **Povezava na Wi-Fi senzorja:** Vodniček z ilustracijo gumbov **`CAL` + `TRG`** uporabnika vodi, da aktivira dostopno točko senzorja in izbere Wi-Fi omrežje **`SOILSENS-V5W`**.
  2. **Vnos domačega Wi-Fi omrežja in samodejna konfiguracija v ozadju:** Uporabnik vpiše le geslo svojega domačega Wi-Fi omrežja. Mobilna aplikacija v ozadju sama ustvari konfiguracijo (naslov centralnega **Mosquitto MQTT Brokerja**, interval pošiljanja in enolični `plant_entity_id`, vezan na uporabnikov profil) ter jo pošlje senzorju.
  3. **Izbira vrste rastline in poimenovanje:** Za uporabnika se rastlina shrani, nakar v čarovniku prek **OpenPlantbook API** izbere dejansko vrsto rastline (npr. *Monstera deliciosa*), jo poljubno poimenuje (npr. *"Living Room Monstera"*) in določi prostor (*Living Room / Balcony / Office*).

### F3: Pregleden seznam rastlin (*My Plants*) in podrobni zgodovinski grafi (*Plant Details*)
* **Namen:** Ločitev hitrega pregleda od podrobne analitike, da uporabnik ni zasut z informacijami na prvem zaslonu.
* **Delovanje:**
  * **Seznam rastlin (*My Plants*):** Prikazuje kartice vseh rastlin z njihovim imenom, vrsto, prostorom in barvno značko zdravja (`98% Healthy` ali `Needs Water • 18%`).
  * **Podrobnosti rastline (*Plant Details*):** Ob kliku na posamezno rastlino se prikažejo trenutne meritve v primerjavi z optimalnimi mejami (`Soil Moisture`, `Temperature`, `Air Humidity`, `Light / DLI`) ter zgodovinski grafi (**24h, 7d, 30d**) z označenim optimalnim območjem (*Target Zone*), ki se berejo iz **TimescaleDB** neprekinjenih agregatov prek **FastAPI**.

### F4: Standardiziran MQTT + Telegraf zajem v TimescaleDB
* **Namen:** Zanesljiv, skalabilen in strojno neodvisen zajem podatkov.
* **Delovanje:** Vsak senzor pošilja meritve v predpisanem standardiziranem JSON formatu na **Mosquitto MQTT Broker**. Agent **Telegraf** sporočila samodejno bere iz Mosquitta in jih neposredno zapisuje v **TimescaleDB** hipertabelo `plant_metrics`.

### F5: Integracija z OpenPlantbook API in izračun ocene zdravja (*Plant Health Score*)
* **Namen:** Samodejna pridobitev optimalnih bioloških pragov za izbrano vrsto rastline (`species`) in njihovo lokalno shranjevanje v bazo **Hive** na napravi.

### F6: Igrifikacija – Sistem nizov (*Plant Health Streaks*)
* **Namen:** Dolgoročna motivacija uporabnika za redno skrb za rastline z beleženjem zaporednih dni optimalnega zdravja vrta.

### F7: Upravljanje profila (*Hive + Firebase Auth*) in potisnih obvestil (*Settings*)
* **Namen:** Preprost zaslon z nastavitvami, kjer uporabnik upravlja:
  * **Račun in varnostno kopiranje:** Privzeti lokalni profil na napravi (**Hive** – brez obvezne prijave), gumb za prijavo in sinhronizacijo prek **Firebase Authentication**, **odjavo (*Log Out*)** ter **izbris računa (*Delete Account*)**.
  * **Potisna sporočila (*Push Notifications*):** Stikala za opomnike za zalivanje (*Watering Reminders*), dnevne opomnike za niz (*Daily Streak Notifications*) in opozorila o nizki bateriji senzorja (*Low Sensor Battery Alerts*).

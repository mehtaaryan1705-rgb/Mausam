# Mausam (मौसम) • Persona-Aware Weather App
### Smart India Hackathon (SIH 2026) — Problem Statement PS 26076
**Ministry of Earth Sciences (MoES) • India Meteorological Department (IMD)**

---

## 🌤️ Executive Summary
Traditional weather applications show an identical, generic meteorological feed to all citizens regardless of their daily needs. **Mausam 2.0** reimagines India's official weather homepage by introducing a **persona-aware, dynamic feed architecture**. 

On first launch, citizens pick one or more personas (e.g. *Health-conscious*, *Outdoor fitness enthusiast*, *Farmer / Gardener*, *Commuter*). The home feed automatically adapts, rendering tailored Material 3 cards prioritized for their activities, while supporting seamless offline caching for rural and transit reliability.

---

## 🏛️ Government Data Source Integration Matrix

| Persona Profile | Key Metrics & Features | Upstream Government Data Source | Integration Marker in Code |
| :--- | :--- | :--- | :--- |
| **1. Health-Conscious** | NAQI 6-color scale, PM2.5, PM10, UV, Pollen, AQI > 200 alert | **CPCB** (Central Pollution Control Board) CAAQMS | `lib/ui/features/home/widgets/cards/health_card.dart` |
| **2. Outdoor Fitness** | Calculated Best Running Hours (temp+wind+AQI), Sunrise/Sunset | **IMD** Surface AWS & Solar Ephemeris | `lib/ui/features/home/widgets/cards/outdoor_fitness_card.dart` |
| **3. Beachgoers & Surfers** | High/Low Tide tables, wave height, sea roughness, water temp | **INCOIS** (Indian National Centre for Ocean Info) | `lib/ui/features/home/widgets/cards/beach_surfer_card.dart` |
| **4. Travelers** | Saved destinations, severe weather alerts, packing generator | **IMD** National Multi-City Forecast & Warnings | `lib/ui/features/home/widgets/cards/traveler_card.dart` |
| **5. Parents & Families** | School commute windows (7-9 AM & 2-4 PM), rain alerts | **IMD** Doppler Weather Radar (DWR) Nowcast | `lib/ui/features/home/widgets/cards/parents_families_card.dart` |
| **6. Agriculture & Gardeners** | Soil moisture %, 48h rainfall prediction, seasonal GKMS crop tip | **IMD** Agromet Advisory Services (Gramin Krishi Mausam) | `lib/ui/features/home/widgets/cards/agriculture_card.dart` |
| **7. Commuters** | Weather + traffic overlay, visibility in meters, fog/storm alert | **IMD** Highway Nowcast & Urban Traffic Mesh | `lib/ui/features/home/widgets/cards/commuter_card.dart` |
| **8. Event Planners** | 7-10 day forecast, rain probability, 0-100 Comfort Index formula | **IMD** Extended Range Forecast (ERF 7-15 Days) | `lib/ui/features/home/widgets/cards/event_planner_card.dart` |

---

## 🏗️ Architecture & Clean Separation of Concerns

```
mausam_app/
├── lib/
│   ├── data/
│   │   ├── models/
│   │   │   ├── weather_data.dart         # Comprehensive typed models for all 8 personas
│   │   │   ├── persona_type.dart         # 8 Personas enum, metadata & icons
│   │   │   └── user_preferences.dart     # SharedPreferences persistence model
│   │   ├── repositories/
│   │   │   └── weather_repository.dart   # Offline-first caching & single source of truth
│   │   └── services/
│   │       ├── mock_weather_data.dart    # Rich Indian datasets (Delhi, Mumbai, Bengaluru, etc.)
│   │       └── weather_service.dart      # Real API TODO hooks, running & comfort formulas
│   ├── viewmodels/
│   │   ├── persona_viewmodel.dart        # Multi-persona selection & state
│   │   └── weather_viewmodel.dart        # Live weather state, city switching & offline handling
│   ├── ui/
│   │   ├── core/
│   │   │   ├── theme.dart                # Material 3 MoES/IMD branding & dark mode
│   │   │   └── widgets/
│   │   │       ├── offline_banner.dart   # Degraded mode cached banner with retry
│   │   │       └── weather_badge.dart    # Reusable status tags
│   │   └── features/
│   │       ├── onboarding/
│   │       │   └── onboarding_screen.dart # Multi-select onboarding flow
│   │       ├── home/
│   │       │   ├── home_screen.dart       # Dynamic scrollable feed of active cards
│   │       │   └── widgets/
│   │       │       ├── hero_weather_header.dart # City picker & hero current weather
│   │       │       ├── persona_selector_bar.dart # Filter chips & customization jump
│   │       │       └── cards/
│   │       │           ├── health_card.dart
│   │       │           ├── outdoor_fitness_card.dart
│   │       │           ├── beach_surfer_card.dart
│   │       │           ├── traveler_card.dart
│   │       │           ├── parents_families_card.dart
│   │       │           ├── agriculture_card.dart
│   │       │           ├── commuter_card.dart
│   │       │           └── event_planner_card.dart
│   │       └── settings/
│   │           └── settings_screen.dart   # Edit personas, switch city, toggle offline demo
│   ├── l10n/
│   │   ├── app_en.arb                     # English localization
│   │   └── app_hi.arb                     # Hindi (मौसम) localization
│   └── main.dart                          # App bootstrap & MultiProvider
├── backend/                               # Companion Node.js Express proxy layer
│   ├── server.js                          # REST endpoints matching Flutter models
│   ├── package.json
│   └── mock_data/
│       ├── weather_delhi.json             # Inland sample payload
│       └── weather_mumbai.json            # Coastal sample payload (INCOIS active)
└── test/
    ├── comfort_index_test.dart            # Flutter test suite
    ├── weather_model_test.dart            # Model deserialization test suite
    └── verify_algorithms.py               # Standalone algorithmic verification script
```

---

## ⚡ Key Highlights & SIH Differentiators

1. **Bilingual Localization (English & हिंदी) & First-Launch Language Selection**
   - First screen shown upon initial launch offers high-contrast, bilingual selection cards for **English** and **हिंदी (Hindi)**.
   - Saves selection to local preferences with live locale switching across all 8 persona cards.
   - Built on official standard Flutter localization (`l10n.yaml`, `app_en.arb`, `app_hi.arb`).
   - Official **CPCB NAQI terminology in Hindi**: *अच्छा (Good), संतोषजनक (Satisfactory), मध्यम (Moderate), खराब (Poor), बहुत खराब (Very Poor), गंभीर (Severe)*.
   - Built-in weather conditions dictionary mapping IMD sky states (*Hazy Sunshine -> धुंधली धूप, Thunderstorms & Rain -> गरज के साथ बारिश, Clear -> साफ आसमान*).
   - "Change Language / भाषा बदलें" option accessible in Settings at any time.

2. **Universal Location Search (India-First with Graceful Global Fallback)**
   - Type-ahead search modal with 350-400ms debouncing supporting any city, town, village, or global metropolis worldwide (e.g. London, Dubai, Tokyo, New York).
   - **GPS "Use Current Location"**: One-tap device geolocation via `geolocator` with automatic reverse geocoding to the nearest monitoring station.
   - **Recent & Saved Searches**: Persists up to 8 recent locations across sessions, supporting both domestic and global destinations.
   - **India-First Scope Rule**:
     - *Within India*: Full experience across all 8 personas (CPCB CAAQMS, INCOIS coastal ocean state, IMD Agromet advisory).
     - *International (e.g., London)*: Displays core global weather (temperature, humidity, UV index, comfort index, packing suggestions, outdoor running windows) while gracefully noting the Ministry of Earth Sciences (MoES) India mandate on regional cards.
     - *Traveler Persona*: Citizens and jury members can freely add international cities like London, Paris, and Dubai into their saved travel hubs.

3. **Precision Distance-to-Coastline Calculation (25 km Threshold)**
   - Implements high-accuracy equirectangular-projected Haversine point-to-segment distance calculation against the official India coastline polyline (`assets/data/india_coastline.json`).
   - Classifies any location within 25.0 km as coastal (`isCoastal: true`) with exact distance displayed on the card (e.g., *"Coastal • 2.0 km to coast"* or *"Inland • 635 km to coast"*).
   - **Zero Drift Architecture**: Authoritative backend API calculation is matched with an identical client-side offline twin (`CoastalDetector`) sharing the same GeoJSON coordinates and mathematics for offline resiliency.

4. **AQI Station Transparency & Environmental Integrity**
   - The Health & Air Quality card directly attributes live data to the nearest Central Pollution Control Board (CPCB) Continuous Ambient Air Quality Monitoring Station (CAAQMS) with exact distance (e.g., *"CAAQMS Anand Vihar Central • 3.2 km away"*).

5. **Cross-Platform Mobile & Web Architecture (Adaptive Responsive Layout)**
   - **Unified Single Codebase**: Runs natively across **Mobile (Android / iOS)**, **Web (Chrome, Edge, Safari)**, and **Desktop (Windows)**.
   - **Mobile Bottom Navigation Bar**: Material 3 bottom dock with **Feed (होम फ़ीड)**, **Dashboard (डैशबोर्ड)**, **Search (खोजें)**, and **Settings (सेटिंग्स)** for thumb-friendly mobile navigation.
   - **Dedicated Mobile Weather Dashboard**:
     - *Quick Weather Hero*: High-contrast current temperature, condition, feels like, min/max temp.
     - *3x2 Vitals Grid*: Humidity, Wind speed & direction, UV index, Visibility, Pressure, and Sunrise/Sunset.
     - *National Air Quality & CAAQMS Attribution*: Station name + distance in km.
     - *Marine & Coast Proximity Indicator*: Real-time tidal and wave telemetry or distance to coast.
     - *Saved Travel Cities Watchlist*: Horizontal swipeable cards for tracking domestic and international destinations.
   - **Responsive Screen Container**: On mobile viewports (< 720px), elements expand edge-to-edge with touch ergonomics. On desktop/tablet displays (>= 720px), the layout elegantly centers within an optimal 720px width, preventing awkward horizontal stretching.
   - **Android Native Ready**: Fully configured in `android/app/src/main/AndroidManifest.xml` with `INTERNET` and `ACCESS_FINE_LOCATION` permissions.

6. **Multi-Persona Selection & Dynamic Feed**
   - Users are not pigeonholed into a single persona; a user can be both a *Parent* and an *Outdoor Fitness Runner*.
   - The homepage dynamically reorders and renders only the widgets matching the user's active selections.

7. **Offline-First Degraded Mode (Crucial for India)**
   - Connectivity in rural India or transit can drop. Mausam automatically stores the full JSON snapshot in `SharedPreferences` with visual offline caching badges and retry actions.
   - When offline, a clear banner alerts the citizen: *"Working Offline — Showing cached data from 10:15 AM (Tap to retry)"*.
   - A toggle in **Settings -> Offline Demo Mode** lets judges test this behavior on demand.

4. **Algorithmic Intelligence**
   - **Best Running Hours**: Calculates time windows factoring temperature ($18^\circ\text{C}-28^\circ\text{C}$), low wind speed, and safe AQI.
   - **Comfort Index (0-100)**: Combines temperature, relative humidity, and wind speed into a single event planning index.
   - **Smart Packing Assistant**: Rule-based engine analyzing rain probabilities, high UV index, cold spells, and AQI.

---

## 🚀 How to Run

### 1. Flutter Mobile App
Ensure Flutter SDK is installed on your system.
```bash
# 1. Navigate to the app directory
cd mausam_app

# 2. Fetch dependencies
flutter pub get

# 3. Run on connected mobile device, emulator, or Chrome web
flutter run
```

### 2. Companion Node.js Express Backend (Optional Proxy)
```bash
# 1. Navigate to backend directory
cd mausam_app/backend

# 2. Install dependencies
npm install

# 3. Start the server
npm start
# -> Running on http://localhost:3000
```

Available backend endpoints:
- `GET http://localhost:3000/api/weather/:city`
- `GET http://localhost:3000/api/aqi/:city`
- `GET http://localhost:3000/api/marine/:city`
- `GET http://localhost:3000/api/personas/feed?city=mumbai&personas=health,fitness`

---

## 🔌 Swapping Mock Data with Real Government APIs

Every data service and card has clear `TODO: [API INTEGRATION]` comments specifying the real endpoint format:

1. **IMD Weather & Radar (`weather_service.dart`)**:
   ```dart
   // Replace mock delay with HTTP call:
   final response = await http.get(
     Uri.parse('https://mausam.imd.gov.in/api/v1/aws/$cityName'),
     headers: {'Authorization': 'Bearer $MOES_API_KEY'},
   );
   ```

2. **CPCB Air Quality (`health_card.dart` & `weather_service.dart`)**:
   ```dart
   // Query CAAQMS station-level data:
   final response = await http.get(
     Uri.parse('https://app.cpcbccr.com/AQI_Serv/aqi_data?station=$stationId'),
   );
   ```

3. **INCOIS Ocean State Forecast (`beach_surfer_card.dart` & `weather_service.dart`)**:
   ```dart
   // Query ocean swell and high/low tide predictions:
   final response = await http.get(
     Uri.parse('https://incois.gov.in/portal/osf/tide_api.jsp?port=$coastalPort'),
   );
   ```

---

## 🧪 Testing & Verification
Run the algorithm and data integrity test suite:
```bash
# Python verification script
python test/verify_algorithms.py

# Flutter test suite
flutter test
```

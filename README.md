# EZ Bike CRM 🏍️

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-%23039BE5.svg?style=flat&logo=Firebase&logoColor=white)](https://firebase.google.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern, cross-platform Asset Management & CRM system designed for the bike rental industry. Built with **Flutter**, **Riverpod**, and **Firebase**, this project serves as a high-quality reference for building offline-first, real-time business applications.

## 🌟 Project Overview

EZ Bike CRM was originally conceived as a lightweight, affordable solution for the Vietnamese scooter rental market. It bridges the gap between traditional "pen and paper" methods and complex, expensive enterprise software by focusing on the core essentials of fleet management: **Real-time status tracking**, **Rental processing**, and **Financial reporting**.

### Key Business Problems Solved:
- **Fleet Visibility:** Instant overview of which bikes are in the garage, out on rent, or in maintenance.
- **Financial Transparency:** Tracking deposits, daily earnings, and maintenance costs without manual spreadsheet errors.
- **Data Integrity:** Moving away from fragile paper logs to a secure, user-isolated cloud database.

---

## 🚀 Technical Highlights

### 1. Robust State Management (Riverpod)
The application utilizes **Riverpod 2.0** with code generation for scalable, testable, and reactive state management. 
- **ViewModel Pattern:** Clear separation of UI logic and business logic via `StateNotifier`.
- **Auto-Dispose:** Efficient memory management for temporary UI states.

### 2. Custom Caching Layer (Firebase Realtime DB)
To ensure high performance and reduce network overhead, a **custom in-memory caching layer** is implemented on top of the Firebase Realtime Database.
- **Selective Refresh:** Fetches only what is needed, serving the rest from cache.
- **User Isolation:** Automatically handles user-specific paths (`users/$uid/...`) for data security.

### 3. Multi-Language Support (i18n)
Full localization for **English** and **Vietnamese**, using `.arb` files and the `intl` package. The app handles currency formatting (VND) and date localization natively.

### 4. Advanced Reporting & Excel Export
The "Reports" feature provides financial summaries (Earnings, Costs, Balance) and fleet status snapshots. 
- **Web-native Excel Export:** Utilizes the `excel` package to generate professional financial reports directly in the browser.

---

## 🏗️ Architecture

```text
lib/
├── data/               # Repository layer & Data models
│   ├── models/         # Immutable Equatable models
│   └── db_services/    # Low-level Firebase wrappers
├── services/           # Domain/Business logic layer
├── features/           # UI features organized by domain
│   └── [feature]/      # Screens, ViewModels, and Widgets
├── providers/          # Global Riverpod provider definitions
├── l10n/               # Localization (English/Vietnamese)
└── utils/              # Theming, Validators, and Shared imports
```

---

## 🛠️ Installation & Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.3.0)
- [Firebase Account](https://firebase.google.com/)

### Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/ez_bike_crm.git
   cd ez_bike_crm
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   Install the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) and run:
   ```bash
   flutterfire configure
   ```
   This will regenerate the `lib/firebase_options.dart` file with your specific project credentials.

4. **Run the App:**
   ```bash
   flutter run
   ```

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

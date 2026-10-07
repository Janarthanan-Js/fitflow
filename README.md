# FitFlow 💪

**Your Personal Fitness Tracking Companion**

FitFlow is a Flutter-based fitness tracking application that helps you plan workouts,
log your sessions, monitor your progress, and stay consistent with your fitness goals.

---

## ✨ Features

- **Personalized Profile** — Track your name, goals, and body metrics.
- **Workout Logging** — Add and record workouts with duration, type, and details.
- **Workout Plans** — Follow structured plans to stay on track.
- **Statistics & Charts** — Visualize your progress with interactive charts (`fl_chart`).
- **Achievements** — Stay motivated by unlocking milestones.
- **Offline-first Storage** — All data is stored locally on-device using Hive.
- **Clean Material UI** — A modern, responsive interface built with Material Design.

## 🧱 Tech Stack

| Layer | Technology |
| --- | --- |
| Framework | Flutter (Dart) |
| State Management | Provider |
| Local Database | Hive + hive_flutter |
| Preferences | shared_preferences |
| Charts | fl_chart |
| Utilities | intl, flutter_svg |

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point & initialization
├── models/                   # Data models (Hive types + generated adapters)
│   ├── user_profile.dart
│   └── workout_record.dart
├── screens/                  # UI screens
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── workouts_screen.dart
│   ├── add_workout_screen.dart
│   ├── plans_screen.dart
│   ├── statistics_screen.dart
│   └── profile_screen.dart
├── services/                 # Storage & business services
│   └── storage_service.dart
├── theme/                    # App theming
│   └── app_theme.dart
├── utils/                    # Helper utilities
└── widgets/                  # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Dart 3.9.2+)
- An Android device/emulator or a web browser for preview

### Setup

```bash
# Clone the repository
git clone https://github.com/<your-username>/fitflow.git
cd fitflow

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Android

```bash
flutter build apk --release
```

The output APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## 🔒 Data & Privacy

All fitness data is stored **locally on your device** using Hive. No personal data is
uploaded to any server.

## 📄 License

This project is provided as-is for personal use.

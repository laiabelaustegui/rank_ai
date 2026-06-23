# Rank AI

A Flutter mobile application that integrates with AI services for intelligent ranking and search capabilities. Built with Flutter, BLoC state management, and modern UI/UX patterns.

## 📋 Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Technologies Used](#technologies-used)

## ✨ Features

- AI-powered search and ranking functionality
- Network-based API integration with caching
- Shimmer loading effects for enhanced UX
- Local storage with shared preferences
- State management using BLoC pattern
- Material Design UI
- Support for Android and iOS platforms

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version ^3.12.2 ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: Version ^3.12.2 (included with Flutter)
- **Git**: For version control
- **Android Studio** or **Xcode**: 
  - Android Studio with Android SDK (for Android development)
  - Xcode (for iOS development on macOS)

### Verify Installation

Run the following command to verify your Flutter installation:

```bash
flutter doctor
```

All items should have checkmarks before proceeding.

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd rank_ai
```

### 2. Install Dependencies

Fetch and install all required Flutter packages:

```bash
flutter pub get
```

### 3. (Optional) Generate Build Files

If needed, generate required build files:

```bash
flutter pub run build_runner build
```

### 4. Configure API Key

This application uses OpenAI's API for AI-powered ranking functionality. You need to add your OpenAI API key to run the app:

#### Get Your OpenAI API Key

1. Go to [OpenAI API](https://platform.openai.com/api/keys)
2. Sign in with your OpenAI account (or create one if you don't have one)
3. Click **Create new secret key**
4. Copy the generated API key (keep it safe and secure)

#### Add API Key to the Project

1. Open [lib/core/constants/api_constants.dart](lib/core/constants/api_constants.dart)
2. Find the line:
   ```dart
   static const String openAiApiKey = 'your-api-key-here';
   ```
3. Replace `'your-api-key-here'` with your actual OpenAI API key:
   ```dart
   static const String openAiApiKey = 'sk-proj-YOUR_ACTUAL_API_KEY_HERE';
   ```

#### ⚠️ Important Security Notes

- **NEVER commit your API key** to the repository

## ▶️ Running the Application

### Run on Android Device/Emulator

```bash
flutter run
```

Or with more verbose output:

```bash
flutter run -v
```

### Run on iOS Device/Simulator (macOS only)

```bash
flutter run -d iphone
```

### Build Release APK (Android)

```bash
flutter build apk --release
```

### Build iOS App Bundle

```bash
flutter build ios --release
```

### Run with Specific Device

List available devices:

```bash
flutter devices
```

Run on a specific device:

```bash
flutter run -d <device-id>
```

## 📂 Project Structure

```
rank_ai/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── core/
│   │   ├── constants/            # App-wide constants
│   │   └── theme/                # Theme and styling
│   ├── data/
│   │   ├── models/               # Data models and entities
│   │   ├── repositories/         # Repository pattern implementations
│   │   └── services/             # API services and HTTP clients
│   ├── ui/
│   │   ├── blocs/                # BLoC state management
│   │   ├── screens/              # Application screens/pages
│   │   └── widgets/              # Reusable UI widgets
│   └── test/                     # Unit and widget tests
├── android/                      # Android native code
├── ios/                          # iOS native code
├── pubspec.yaml                  # Project dependencies and configuration
├── analysis_options.yaml         # Dart analysis rules
└── README.md                     # This file
```

## 📚 Dependencies

### Core Dependencies

- **flutter_bloc** (^9.1.1): State management using BLoC pattern
- **equatable** (^2.0.5): Value equality for Dart objects
- **http** (^1.2.0): HTTP client for API requests
- **cupertino_icons** (^1.0.8): iOS-style icons

### UI/UX Dependencies

- **cached_network_image** (^3.3.1): Image caching and optimization
- **shimmer** (^3.0.0): Skeleton loading effects
- **url_launcher** (^6.3.2): URL launching capabilities

### Local Storage

- **shared_preferences** (^2.5.5): Local data persistence

## 🛠️ Technologies Used

| Technology | Purpose |
|-----------|---------|
| Flutter | Cross-platform mobile app framework |
| Dart | Programming language |
| BLoC | State management pattern |
| HTTP | Network requests |
| SharedPreferences | Local storage |
| Material Design | UI design system |

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
3. Push to the branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request

## 📖 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Material Design](https://material.io/design)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Last Updated**: 2026-06-23
**Version**: 1.0.0

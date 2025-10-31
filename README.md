# 🧘 Happier Meditation

A professional Flutter meditation and mindfulness application featuring guided meditations, sleep stories, breathing exercises, and AI-powered wellness coaching.

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![GetX](https://img.shields.io/badge/State%20Management-GetX-9C27B0)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📱 Features

### 🎯 Core Features

- **Guided Meditations** - Curated meditation courses with multiple sessions
- **Sleep Stories** - Calming audio stories for better sleep
- **Short Practices** - Quick meditation sessions for busy schedules
- **Breathing Exercises** - Guided breathing techniques
- **Wisdom Shorts** - Bite-sized mindfulness wisdom
- **Podcasts** - Mindfulness and wellness podcast episodes

### 🤖 AI-Powered Features

- **AI Chatbot** - Gemini AI-powered wellness coach for personalized guidance
- **Smart Recommendations** - Content recommendations based on user behavior

### ✨ User Experience

- **Dark/Light Themes** - Beautiful adaptive themes with smooth transitions
- **Offline Downloads** - Download content for offline listening
- **Favorites System** - Save and organize your favorite content
- **Progress Tracking** - Track meditation streaks and achievements
- **History** - View your meditation journey
- **Background Audio** - Continue meditation with screen off

### 🔐 Authentication

- **Google Sign-In** - Seamless authentication
- **Account Management** - Profile settings and preferences
- **Multi-device Sync** - Cloud-based user data synchronization

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── common_widgets/          # Reusable UI components (cards, buttons, etc.)
├── controllers/             # Business logic (GetX Controllers with bindings)
├── core/
│   ├── config/             # App configuration (Cloudinary, etc.)
│   ├── constants/          # App constants and colors
│   ├── routes/             # Navigation routes (app_pages.dart, app_routes.dart)
│   ├── services/           # Core services (Auth, Cloudinary, Downloads, History)
│   ├── theme/              # Theme configuration (dark/light mode)
│   └── utils/              # Utility functions (navigation helpers, etc.)
├── data/
│   └── models/             # Data models (Hive entities for local storage)
├── repository/             # Repository pattern implementation
├── views/                  # UI screens (each with screens/ and widgets/ folders)
│   ├── splash_view/
│   │   ├── screens/
│   │   └── widgets/
│   ├── main_scaffold/      # Main app scaffold with bottom navigation
│   │   ├── screens/
│   │   └── widgets/
│   └── [38+ more views]/
├── firebase_options.dart
├── get_it.dart             # Dependency injection setup
└── main.dart               # App entry point
```

### 🎨 Design Patterns Used

- **Repository Pattern** - Data access abstraction
- **Dependency Injection** - GetIt service locator
- **MVC Pattern** - Model-View-Controller architecture
- **Singleton Pattern** - Service instances
- **Observer Pattern** - Reactive state management (GetX)

---

## 🛠️ Tech Stack

### Framework & Language

- **Flutter** 3.8.1
- **Dart** SDK ^3.8.1

### State Management

- **GetX** 4.6.6 - Reactive state management, routing, and dependency injection

### Backend & Services

- **Firebase Core** - Backend infrastructure
- **Firebase Auth** - User authentication
- **Cloud Firestore** - NoSQL cloud database
- **Firebase Storage** - Media file storage
- **Firebase Analytics** - User analytics
- **Firebase Crashlytics** - Crash reporting
- **Google Sign-In** - OAuth authentication

### Local Storage

- **Hive** 2.2.3 - Fast, lightweight NoSQL local database
- **SharedPreferences** - Key-value persistent storage

### Media & Content

- **Cloudinary** - Cloud-based media management and CDN
- **Just Audio** - Advanced audio playback
- **Audio Service** - Background audio support
- **Video Player** - Video content playback
- **Chewie** - Video player UI controls

### AI & Chat

- **Google Generative AI** (Gemini) - AI-powered chatbot

### UI/UX Libraries

- **Lottie** - Beautiful animations
- **Cached Network Image** - Optimized image loading
- **Shimmer** - Loading skeleton effects
- **FL Chart** - Statistics and progress charts
- **Google Fonts** - Custom typography

### Utilities

- **Dio** - HTTP client
- **Logger** - Advanced logging
- **flutter_dotenv** - Environment variable management
- **Package Info Plus** - App version information
- **URL Launcher** - External link handling
- **Connectivity Plus** - Network status monitoring

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: ^3.8.1
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase Account** (for backend services)
- **Cloudinary Account** (for media CDN)
- **Google AI Studio Account** (for Gemini API)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Bhumik16/happier.git
   cd happier
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Create `.env` file** in the project root

   ```env
   CLOUDINARY_CLOUD_NAME=your_cloud_name
   CLOUDINARY_API_KEY=your_api_key
   CLOUDINARY_API_SECRET=your_api_secret
   GEMINI_API_KEY=your_gemini_api_key
   ```

4. **Configure Firebase**

   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and place in `android/app/`
   - Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
   - Run: `flutterfire configure` (or use existing `firebase_options.dart`)

5. **Enable Firebase Services**

   - Enable **Authentication** (Google Sign-In)
   - Enable **Cloud Firestore**
   - Enable **Firebase Storage**
   - Enable **Firebase Analytics**
   - Enable **Firebase Crashlytics**

6. **Generate Hive Type Adapters** (if needed)

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

7. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔑 Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Cloudinary Configuration (for media CDN)
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret

# Google AI Studio (for Gemini chatbot)
GEMINI_API_KEY=your_gemini_api_key
```

### How to Get API Keys:

**Cloudinary:**

1. Sign up at [Cloudinary](https://cloudinary.com)
2. Go to Dashboard → Account Details
3. Copy Cloud Name, API Key, and API Secret

**Gemini API:**

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the API key

---

## 📱 Firebase Setup

### 1. Create Firebase Project

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
flutterfire configure
```

### 2. Configure Authentication

- Go to Firebase Console → Authentication → Sign-in method
- Enable **Google** sign-in provider
- Add your app's SHA-1 fingerprint (Android)

### 3. Configure Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /meditations/{document=**} {
      allow read: if request.auth != null;
    }
    match /courses/{document=**} {
      allow read: if request.auth != null;
    }
  }
}
```

### 4. Configure Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user_uploads/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /public/{allPaths=**} {
      allow read: if request.auth != null;
    }
  }
}
```

---

## 🏃 Running the App

### Development Mode

```bash
flutter run
```

### Release Mode (Android)

```bash
flutter build apk --release
flutter build appbundle --release
```

### Release Mode (iOS)

```bash
flutter build ios --release
```

### Web

```bash
flutter run -d chrome
```

---

## 📂 Project Structure

```
happier_meditation/
│
├── android/                 # Android native code
├── ios/                     # iOS native code
├── lib/
│   ├── common_widgets/      # Reusable UI components
│   │   ├── bottom_nav_bar.dart
│   │   ├── course_card.dart
│   │   ├── meditation_card.dart
│   │   ├── single_card.dart
│   │   ├── podcast_card.dart
│   │   └── practice_video_card.dart
│   │
│   ├── controllers/         # GetX Controllers (Business Logic)
│   │   ├── splash_controller/
│   │   ├── auth_controller/
│   │   ├── home_controller/
│   │   ├── courses_controller/
│   │   ├── chatbot_controller/
│   │   ├── downloads_controller/
│   │   ├── history_controller/
│   │   ├── settings_controller/
│   │   └── [20+ more controllers]/
│   │
│   ├── core/
│   │   ├── config/          # App configuration
│   │   │   └── cloudinary_config.dart
│   │   ├── constants/       # App constants
│   │   │   └── app_colors.dart
│   │   ├── routes/          # Navigation routes
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   ├── services/        # Core services
│   │   │   ├── auth_service.dart
│   │   │   ├── cloudinary_service.dart
│   │   │   ├── downloads_service.dart
│   │   │   └── history_service.dart
│   │   ├── theme/           # Theme configuration
│   │   │   └── app_theme.dart
│   │   └── utils/           # Utility functions
│   │       └── navigation_helper.dart
│   │
│   ├── data/
│   │   └── models/          # Data models (Hive entities)
│   │       ├── meditation_model.dart
│   │       ├── course_model.dart
│   │       └── [10+ more models]
│   │
│   ├── repository/          # Repository layer
│   │   ├── meditation_repository/
│   │   ├── course_repository/
│   │   └── [5+ more repositories]
│   │
│   ├── views/               # UI Screens (39 view folders)
│   │   ├── splash_view/
│   │   │   └── screens/
│   │   ├── main_scaffold/   # Main app with bottom navigation
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── home_view/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── courses_view/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── chatbot_view/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── [34+ more views]/
│   │       └── Each with screens/ and widgets/ folders
│   │
│   ├── firebase_options.dart
│   ├── get_it.dart          # Dependency injection setup
│   └── main.dart            # App entry point
│
├── assets/
│   ├── animations/          # Lottie animations
│   ├── audios/              # Audio files
│   ├── fonts/               # Custom fonts
│   ├── icons/               # App icons
│   ├── images/              # Images
│   └── videos/              # Video files
│
├── test/                    # Unit & widget tests
├── .env                     # Environment variables (DO NOT COMMIT)
├── .gitignore
├── pubspec.yaml             # Dependencies
└── README.md
```

---

## 🎨 Key Features Implementation

### GetIt Dependency Injection

```dart
// get_it.dart
Future<void> setupDependencyInjection() async {
  final getIt = GetIt.instance;

  // Register repositories as lazy singletons
  getIt.registerLazySingleton<MeditationRepository>(() => MeditationRepository());
  getIt.registerLazySingleton<CourseRepository>(() => CourseRepository());
  // ... more repositories
}
```

### Repository Pattern

```dart
// meditation_repository.dart
class MeditationRepository {
  Future<List<MeditationModel>> getAllMeditations() async {
    // Fetch from Firestore or mock service
  }
}
```

### GetX State Management

```dart
// home_controller.dart
class HomeController extends GetxController {
  final _repository = GetIt.I<MeditationRepository>();
  final RxList<MeditationModel> _meditations = <MeditationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMeditations();
  }

  Future<void> loadMeditations() async {
    try {
      final meditations = await _repository.getAllMeditations();
      _meditations.value = meditations;
    } catch (e) {
      // Handle error
    }
  }
}
```

---

## 🧪 Testing

### Run Tests

```bash
flutter test
```

### Generate Coverage Report

```bash
flutter test --coverage
```

---

## 🔧 Configuration

### Change App Name

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<application android:label="Your App Name">
```

Update `ios/Runner/Info.plist`:

```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

### Change Package Name

Use the `change_app_package_name` package:

```bash
flutter pub global activate change_app_package_name
flutter pub global run change_app_package_name:main com.yourcompany.appname
```

Then regenerate Firebase configuration files.

---

## 📦 Build & Release

### Android Release

1. **Create keystore**

   ```bash
   keytool -genkey -v -keystore ~/release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias happier
   ```

2. **Create `android/key.properties`**

   ```properties
   storePassword=your_password
   keyPassword=your_password
   keyAlias=happier
   storeFile=/path/to/release-keystore.jks
   ```

3. **Build release APK/Bundle**
   ```bash
   flutter build appbundle --release
   flutter build apk --release
   ```

### iOS Release

1. Open Xcode: `open ios/Runner.xcworkspace`
2. Configure signing & capabilities
3. Archive and upload to App Store Connect

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

**Bhumik Patel**

- GitHub: [@Bhumik16](https://github.com/Bhumik16)
- Email: bhumikstudent1608@gmail.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Cloudinary for media CDN
- Google AI for Gemini API
- GetX community for state management
- All open-source contributors

---

## 📞 Support

For support, email bhumikstudent1608@gmail.com or open an issue in the repository.

---

## 🗺️ Roadmap

- [ ] Add unit and integration tests
- [ ] Implement payment integration (Razorpay/Stripe)
- [ ] Add more meditation categories
- [ ] Implement push notifications
- [ ] Add social sharing features
- [ ] Multi-language support
- [ ] Apple Sign-In
- [ ] Offline mode improvements
- [ ] Community features

---

**Made with ❤️ and Flutter**

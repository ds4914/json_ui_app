# JSON UI APP - README

## Project Setup Instructions

### Prerequisites
- Flutter SDK (Latest Stable Version)
- Dart SDK
- Firebase Project (for Authentication and Database)
- Android Studio or VS Code (for development)

### Step 1: Clone the Repository
```sh
git clone https://github.com/your-repo/jsonuiapp.git
cd jsonuiapp
```

### Step 2: Install Dependencies
```sh
flutter pub get
```
### Step 3: Run the Application
#### Android
```sh
flutter run
```

#### iOS
```sh
cd ios
pod install
cd ..
flutter run
```


### Project Structure
```
jsonuiapp/
|-- lib/
|   |-- blocs/           # Bloc state management
|   |-- screens/         # UI Screens
|   |-- ui_widgets/      # Custom widgets
|   |-- utils/           # Utility functions
|   |-- main.dart        # Entry point
|-- android/
|-- ios/
|-- pubspec.yaml         # Dependencies
|-- README.md            # Documentation
```

### Key Features
- Dynamic UI Rendering from JSON
- Firebase Authentication (Google, Apple, OTP, Email/Password)
- Cloudinary Integration for media storage
- Dark/Light Mode Toggle
- Bottom Navigation Bar Configuration via JSON
- Bloc State Management

### Troubleshooting
1. **App crashes on startup?**
    - Ensure `google-services.json` and `GoogleService-Info.plist` are properly placed.
    - Run `flutter clean && flutter pub get`.

2. **Firebase authentication not working?**
    - Check Firebase Console Authentication settings.
    - Ensure SHA-1 and SHA-256 fingerprints are added for Android.

3. **Slow image uploads?**
    - Optimize image compression before uploading to Cloudinary.
    - Use async bulk upload methods.

### Contribution Guidelines
- Fork the repository.
- Create a feature branch.
- Commit your changes with descriptive messages.
- Push and create a pull request.

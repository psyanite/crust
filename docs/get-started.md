# 🍞 Get Started

# Android Debug SHA1
* keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey
* password: android

## Get started Android
* Move `crust.jks` into `/android/app`
* Move `google-services.json` into `/android/app`
* Move `key.properties` into `/android`

## Get Started iOS
* Open Xcode
* Open `ios/Runner.xcodeproj`
* Right click the `Runner` folder on the left hand side
* Click `Add Files to "Runner"` 
* Select `GoogleService-Info.plist`

## How to Release
1. Update `config.dart`
1. Update `pubspec.yaml`
1. Run `flutter build appbundle`

## How to rebuild app launcher icons
`flutter pub get && flutter pub run flutter_launcher_icons:main`

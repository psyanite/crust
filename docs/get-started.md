# 🍞 Get Started

# Android Debug SHA1
* keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey
* password: android

## Get started Android
* Move `crust.jks` into `/android/app`
* Move `google-services.json` into `/android/app`
* Move `key.properties` into `/android`

## Get Started iOS
* Download `GoogleService-Info.plist`
* Open Xcode
* Open `ios/Runner.xcodeproj`
* Click `Add Files to "Runner"`
* Drag and drop the plist file underneath the yellow `Runner` folder on the left hand side
* Select `Copy items if needed`
* Click `Add`

## How to Release
1. Update `config.dart`
1. Update `pubspec.yaml`
1. Run `flutter clean && flutter build appbundle --release`

## How to rebuild app launcher icons
`flutter pub get && flutter pub run flutter_launcher_icons:main`

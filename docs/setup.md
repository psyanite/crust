# 🍞 Setup

# Android Debug SHA1
* keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey
* password: android

## Get started
* Move `crust.jks` into `/android/app`
* Move `google-services.json` into `/android/app`
* Move `key.properties` into `/android`

## How to Release
1. Update `config.dart`
1. Update `pubspec.yaml`
1. Run `flutter build appbundle`

## How to rebuild app launcher icons
`flutter pub get && flutter pub run flutter_launcher_icons:main`

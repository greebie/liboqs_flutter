# liboqs_flutter

LibOqs for Flutter

## Getting Started

This project provides a plugin and prototype example for setting up [liboqs] on flutter. It
currently works only for Android devices. You will need [Dart](https://dart.dev/) to use the 
library and run the tests. You will need to set up the [Flutter Framework](https://flutter.dev/) if
you would like to run operating examples in a mobile phone or emulator. We also recommend setting
flutter up on [Android Studio](https://developer.android.com/studio) since it comes with emulators
and other tools that can help you deploy apps.

## Running Prototype Example

This project has pre-built shared objects available for Arm64 and x86_64 abis. If you are using Mac
Catalina or greater, these will be the only compatible formats available to you.

clone the repository

```
git clone https://github.com/greebie/liboqs_flutter
cd liboqs_flutter
```

If you are using Android Studio, you should be able to open the project and run 
`example/lib/main.dart` on your selected emulator or phone. [How to set up your Android phone
with developer options](https://developer.android.com/studio/debug/dev-options).

If you have Flutter properly installed and prefer to use the command line, you can do the following.

```
flutter emulators // shows available emulators
flutter emulators --launch <emulator id> // select an emulator that uses x86_64 or Arm64
flutter run example/lib/main.dart
```

## Running for 32 bit abis

If you want to run this project on a 32-bit abi phone, you will need to add shared objects for the 
x86 and armeabi-v7a to the android/src/main/jniLibs/{abi-name} folders using a desktop that 
supports 32 bit software (Linux, Windows or MacOS < 10.15). 

To do this:

```bash
git clone https://github.com/open-quantum-safe/liboqs
cd liboqs
./scripts/build-android.sh {NDK folder} -a x86 -b {Folder to place library}
```

The NDK folder will depend on your system. This may be something like `~/Library/Android/sdk/ndk/
{version number}` or similar.

## Adding the liboqs_flutter plugin to your own Flutter apps

This plugin has not been published to the flutter repository because the liboqs library is not 
currently supported for production purposes.

// File generated manually / custom.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('VITE_FIREBASE_API_KEY'),
    appId: String.fromEnvironment('VITE_FIREBASE_APP_ID'),
    messagingSenderId: String.fromEnvironment('VITE_FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('VITE_FIREBASE_PROJECT_ID'),
    authDomain: String.fromEnvironment('VITE_FIREBASE_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('VITE_FIREBASE_STORAGE_BUCKET'),
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('VITE_FIREBASE_API_KEY'),
    appId: String.fromEnvironment('ANDROID_FIREBASE_APP_ID'),
    messagingSenderId: String.fromEnvironment('VITE_FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('VITE_FIREBASE_PROJECT_ID'),
    storageBucket: String.fromEnvironment('VITE_FIREBASE_STORAGE_BUCKET'),
  );
}

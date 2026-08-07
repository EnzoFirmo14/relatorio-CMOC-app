// File generated manually / custom.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.env['VITE_FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['VITE_FIREBASE_APP_ID'] ?? '',
        messagingSenderId: dotenv.env['VITE_FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['VITE_FIREBASE_PROJECT_ID'] ?? '',
        authDomain: dotenv.env['VITE_FIREBASE_AUTH_DOMAIN'] ?? '',
        storageBucket: dotenv.env['VITE_FIREBASE_STORAGE_BUCKET'] ?? '',
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['VITE_FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['ANDROID_FIREBASE_APP_ID'] ??
            dotenv.env['VITE_FIREBASE_APP_ID'] ??
            '',
        messagingSenderId: dotenv.env['VITE_FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['VITE_FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['VITE_FIREBASE_STORAGE_BUCKET'] ?? '',
      );
}

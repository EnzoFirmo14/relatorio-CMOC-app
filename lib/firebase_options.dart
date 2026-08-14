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
        apiKey: dotenv.env['VITE_FIREBASE_API_KEY'] ?? 'AIzaSyBncu3UlIYs_NUsKTQQLIJUm_7KXJ3Jc30',
        appId: dotenv.env['VITE_FIREBASE_APP_ID'] ?? '1:279433346974:web:df020affeb3225985ae08f',
        messagingSenderId: dotenv.env['VITE_FIREBASE_MESSAGING_SENDER_ID'] ?? '279433346974',
        projectId: dotenv.env['VITE_FIREBASE_PROJECT_ID'] ?? 'cmoc-relatorio',
        authDomain: dotenv.env['VITE_FIREBASE_AUTH_DOMAIN'] ?? 'cmoc-relatorio.firebaseapp.com',
        storageBucket: dotenv.env['VITE_FIREBASE_STORAGE_BUCKET'] ?? 'cmoc-relatorio.firebasestorage.app',
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['ANDROID_FIREBASE_API_KEY'] ??
            'AIzaSyAscEn1WlFTYcsCYdqrDPZ6JhdeyDuMkwI',
        appId: dotenv.env['ANDROID_FIREBASE_APP_ID'] ??
            '1:279433346974:android:fb05389a58d0d4f45ae08f',
        messagingSenderId: dotenv.env['VITE_FIREBASE_MESSAGING_SENDER_ID'] ?? '279433346974',
        projectId: dotenv.env['VITE_FIREBASE_PROJECT_ID'] ?? 'cmoc-relatorio',
        storageBucket: dotenv.env['VITE_FIREBASE_STORAGE_BUCKET'] ?? 'cmoc-relatorio.firebasestorage.app',
      );
}

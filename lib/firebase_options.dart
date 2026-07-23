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
    apiKey: 'AIzaSyBkEzrbkGFq8jEutYvQvOd6nOST0Vh9siw',
    appId: '1:279433346974:web:df020affeb3225985ae08f',
    messagingSenderId: '279433346974',
    projectId: 'cmoc-relatorio',
    authDomain: 'cmoc-relatorio.firebaseapp.com',
    storageBucket: 'cmoc-relatorio.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkEzrbkGFq8jEutYvQvOd6nOST0Vh9siw',
    appId: '1:279433346974:android:fb05389a58d0d4f45ae08f',
    messagingSenderId: '279433346974',
    projectId: 'cmoc-relatorio',
    storageBucket: 'cmoc-relatorio.firebasestorage.app',
  );
}

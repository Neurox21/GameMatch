// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBPnyZhXdZrIXjKgHAuMgb_O1JAJdxmjFM',
    appId: '1:490483585773:web:0d1475db80f676605a72e4',
    messagingSenderId: '490483585773',
    projectId: 'gamematch-f4787',
    authDomain: 'gamematch-f4787.firebaseapp.com',
    storageBucket: 'gamematch-f4787.appspot.com',
    measurementId: 'G-15D6KLJ7GX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnAaHvf4fwYmZKFCi6MndvJximA3OwOAM',
    appId: '1:490483585773:android:11616120588fef805a72e4',
    messagingSenderId: '490483585773',
    projectId: 'gamematch-f4787',
    storageBucket: 'gamematch-f4787.appspot.com',
  );
}

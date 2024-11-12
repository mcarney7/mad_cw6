// File generated by FlutterFire CLI.
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
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAYcdECEe2NDg3-U52rABWpohdOYzHEJkk',
    appId: '1:881509159120:web:dc35901cc7dbe668318ed5',
    messagingSenderId: '881509159120',
    projectId: 'mad-cw06',
    authDomain: 'mad-cw06.firebaseapp.com',
    storageBucket: 'mad-cw06.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxOL8burQ61ZPofc1TuKe0PfyvhWQS8Kc',
    appId: '1:881509159120:android:d05e49b655982dfb318ed5',
    messagingSenderId: '881509159120',
    projectId: 'mad-cw06',
    storageBucket: 'mad-cw06.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYYvz2yyQ5dJBfNkPRDNqdXswShRI422Y',
    appId: '1:881509159120:ios:9821d8aa5f0c140c318ed5',
    messagingSenderId: '881509159120',
    projectId: 'mad-cw06',
    storageBucket: 'mad-cw06.firebasestorage.app',
    iosBundleId: 'com.example.madCw6',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYYvz2yyQ5dJBfNkPRDNqdXswShRI422Y',
    appId: '1:881509159120:ios:9821d8aa5f0c140c318ed5',
    messagingSenderId: '881509159120',
    projectId: 'mad-cw06',
    storageBucket: 'mad-cw06.firebasestorage.app',
    iosBundleId: 'com.example.madCw6',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAYcdECEe2NDg3-U52rABWpohdOYzHEJkk',
    appId: '1:881509159120:web:15ac202923a175d3318ed5',
    messagingSenderId: '881509159120',
    projectId: 'mad-cw06',
    authDomain: 'mad-cw06.firebaseapp.com',
    storageBucket: 'mad-cw06.firebasestorage.app',
  );
}
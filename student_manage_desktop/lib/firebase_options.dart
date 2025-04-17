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
    apiKey: 'AIzaSyA-rhR8pTfQMv_ltfqrOg0e0X_fFeHKcEQ',
    appId: '1:1013668411253:web:e000060bd8b784aef1453c',
    messagingSenderId: '1013668411253',
    projectId: 'neww-a26d3',
    authDomain: 'neww-a26d3.firebaseapp.com',
    storageBucket: 'neww-a26d3.appspot.com',
    measurementId: 'G-VV6FXVE7CQ',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-rhR8pTfQMv_ltfqrOg0e0X_fFeHKcEQ',
    appId: '1:1013668411253:web:e000060bd8b784aef1453c',
    messagingSenderId: '1013668411253',
    projectId: 'neww-a26d3',
    authDomain: 'neww-a26d3.firebaseapp.com',
    storageBucket: 'neww-a26d3.firebasestorage.app',
    measurementId: 'G-VV6FXVE7CQ',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBiwWoFBqStKgar2WAPS5cnWEn39f_aU88',
    appId: '1:1013668411253:ios:4d33e93dff71a4c4f1453c',
    messagingSenderId: '1013668411253',
    projectId: 'neww-a26d3',
    storageBucket: 'neww-a26d3.firebasestorage.app',
    iosBundleId: 'com.example.studentManageDesktop',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiwWoFBqStKgar2WAPS5cnWEn39f_aU88',
    appId: '1:1013668411253:ios:4d33e93dff71a4c4f1453c',
    messagingSenderId: '1013668411253',
    projectId: 'neww-a26d3',
    storageBucket: 'neww-a26d3.firebasestorage.app',
    iosBundleId: 'com.example.studentManageDesktop',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcSW00rmHUDeZfDOnVpSvZyDQyyp5sRBk',
    appId: '1:1013668411253:android:08f20b3af252de9ff1453c',
    messagingSenderId: '1013668411253',
    projectId: 'neww-a26d3',
    storageBucket: 'neww-a26d3.firebasestorage.app',
  );

}
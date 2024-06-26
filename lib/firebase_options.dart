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
    apiKey: 'AIzaSyD1huX5jp52gF-YUBL6WL1BIo_ysR4Ws-w',
    appId: '1:263158480788:web:fdc3501050dbb85d6e1981',
    messagingSenderId: '263158480788',
    projectId: 'messagewithfirebase',
    authDomain: 'messagewithfirebase.firebaseapp.com',
    storageBucket: 'messagewithfirebase.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAbwidvsuKhAJ06rZP2jtWFG5jptp3L7A',
    appId: '1:263158480788:android:99081853e0df771a6e1981',
    messagingSenderId: '263158480788',
    projectId: 'messagewithfirebase',
    storageBucket: 'messagewithfirebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCgNg1geYR_QpxsV42hp-gp2-y8QDBBIo',
    appId: '1:263158480788:ios:e1f9bb61e2ef159d6e1981',
    messagingSenderId: '263158480788',
    projectId: 'messagewithfirebase',
    storageBucket: 'messagewithfirebase.appspot.com',
    iosBundleId: 'com.example.messegesWithFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCgNg1geYR_QpxsV42hp-gp2-y8QDBBIo',
    appId: '1:263158480788:ios:e1f9bb61e2ef159d6e1981',
    messagingSenderId: '263158480788',
    projectId: 'messagewithfirebase',
    storageBucket: 'messagewithfirebase.appspot.com',
    iosBundleId: 'com.example.messegesWithFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD1huX5jp52gF-YUBL6WL1BIo_ysR4Ws-w',
    appId: '1:263158480788:web:d17bb89be02bd7d96e1981',
    messagingSenderId: '263158480788',
    projectId: 'messagewithfirebase',
    authDomain: 'messagewithfirebase.firebaseapp.com',
    storageBucket: 'messagewithfirebase.appspot.com',
  );
}

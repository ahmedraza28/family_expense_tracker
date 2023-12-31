// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members, no_default_cases
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYLicEt7Tn0z6jDFjivPwleiZK68XjH-0',
    appId: '1:711587106467:android:fd171e2d44a52855f9b916',
    messagingSenderId: '711587106467',
    projectId: 'family-expense-tracker-cd319',
    storageBucket: 'family-expense-tracker-cd319.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBu4ADgk8-VVyh5pFY9C6si5kumn9bEoEA',
    appId: '1:711587106467:ios:43d9609b6f133114f9b916',
    messagingSenderId: '711587106467',
    projectId: 'family-expense-tracker-cd319',
    storageBucket: 'family-expense-tracker-cd319.appspot.com',
    androidClientId: '711587106467-oi831fn9fsnvs7vhrs8p81vqevi0v26p.apps.googleusercontent.com',
    iosClientId: '711587106467-1c4m0fbk6reprfmvj68eivfdbfribl2v.apps.googleusercontent.com',
    iosBundleId: 'com.inceptrafay.familyExpenseTracker',
  );
}

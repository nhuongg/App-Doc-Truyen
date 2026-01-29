// lib/firebase_options.dart
// Cấu hình Firebase - Đọc từ file .env để bảo mật

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Đọc giá trị từ .env
  static String get _apiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get _projectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get _senderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get _authDomain => dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get _storageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: _apiKey,
    appId: dotenv.env['FIREBASE_APP_ID_WEB'] ?? '',
    messagingSenderId: _senderId,
    projectId: _projectId,
    authDomain: _authDomain,
    storageBucket: _storageBucket,
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _apiKey,
    appId: dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '',
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _apiKey,
    appId: dotenv.env['FIREBASE_APP_ID_IOS'] ?? '',
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.example.flutterAppDoctruyen',
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: _apiKey,
    appId: dotenv.env['FIREBASE_APP_ID_MACOS'] ?? '',
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.example.flutterAppDoctruyen',
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: _apiKey,
    appId: dotenv.env['FIREBASE_APP_ID_WINDOWS'] ?? '',
    messagingSenderId: _senderId,
    projectId: _projectId,
    authDomain: _authDomain,
    storageBucket: _storageBucket,
  );
}

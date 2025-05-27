import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBgTZV94TFUxtdjClVkU2Zo9qchVVe4AiY',
    appId: '1:413168549853:web:720094d1ff65e78e5dc034',
    messagingSenderId: '413168549853',
    projectId: 'rastreia-e58d6',
    authDomain: 'rastreia-e58d6.firebaseapp.com',
    storageBucket: 'rastreia-e58d6.firebasestorage.app',
    measurementId: 'G-HGH4SXQ1JM',
  );

  // Valores do arquivo google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgTZV94TFUxtdjClVkU2Zo9qchVVe4AiY',
    appId: '1:413168549853:web:720094d1ff65e78e5dc034',
    messagingSenderId: '413168549853',
    projectId: 'rastreia-e58d6',
    storageBucket: 'rastreia-e58d6.firebasestorage.app',
  );

  // Valores do arquivo GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgTZV94TFUxtdjClVkU2Zo9qchVVe4AiY',
    appId: '1:413168549853:web:720094d1ff65e78e5dc034',
    messagingSenderId: '413168549853',
    projectId: 'rastreia-e58d6',
    storageBucket: 'rastreia-e58d6.firebasestorage.app',
    iosClientId:
        'XXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com', // Você precisará adicionar este valor do seu arquivo iOS
    iosBundleId: 'com.example.stolenItemsApp',
  );
}

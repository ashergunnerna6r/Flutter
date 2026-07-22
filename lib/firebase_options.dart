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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDkcXVyzDFuNRFjhrJERJ69-bVIbaF_d7c",
    appId: "1:164964696077:web:ca04d7de645f0fd6385544",
    messagingSenderId: "164964696077",
    projectId: "gen-lang-client-0998060073",
    authDomain: "gen-lang-client-0998060073.firebaseapp.com",
    storageBucket: "gen-lang-client-0998060073.firebasestorage.app",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDkcXVyzDFuNRFjhrJERJ69-bVIbaF_d7c",
    appId: "1:164964696077:android:com.lingochat.app",
    messagingSenderId: "164964696077",
    projectId: "gen-lang-client-0998060073",
    storageBucket: "gen-lang-client-0998060073.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDkcXVyzDFuNRFjhrJERJ69-bVIbaF_d7c",
    appId: "1:164964696077:ios:com.lingochat.app",
    messagingSenderId: "164964696077",
    projectId: "gen-lang-client-0998060073",
    storageBucket: "gen-lang-client-0998060073.firebasestorage.app",
    iosBundleId: "com.lingochat.app",
  );
}

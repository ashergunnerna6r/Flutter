import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseService = FirebaseService();
  await firebaseService.initializeFCM();

  runApp(LingoChatApp(firebaseService: firebaseService));
}

class LingoChatApp extends StatelessWidget {
  final FirebaseService firebaseService;

  const LingoChatApp({Key? key, required this.firebaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          surface: Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: firebaseService.currentUser != null
          ? AuthScreen(firebaseService: firebaseService)
          : AuthScreen(firebaseService: firebaseService),
    );
  }
}

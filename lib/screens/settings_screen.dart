import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  final FirebaseService firebaseService;
  final UserProfile currentUser;

  const SettingsScreen({
    Key? key,
    required this.firebaseService,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Settings & Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF6366F1),
                  child: Text(
                    currentUser.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      currentUser.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${currentUser.username}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target Lang: ${currentUser.preferredLanguage.toUpperCase()}',
                      style: const TextStyle(color: Color(0xFF818CF8), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: const Icon(Icons.logout, color: Colors.roseAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.roseAccent, fontWeight: FontWeight.bold)),
            onTap: () async {
              await firebaseService.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AuthScreen(firebaseService: firebaseService)),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

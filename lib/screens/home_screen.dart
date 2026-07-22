import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import '../services/gemini_service.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseService firebaseService;
  final UserProfile currentUser;
  final GeminiService geminiService = GeminiService(apiKey: "AIzaSy_demo_key");

  HomeScreen({
    Key? key,
    required this.firebaseService,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('LingoChat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    firebaseService: firebaseService,
                    currentUser: currentUser,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserProfile>>(
        stream: firebaseService.getUsersStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!
              .where((u) => u.uid != currentUser.uid)
              .toList();

          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No other users online yet.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF6366F1),
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '@${user.username} • ${user.preferredLanguage.toUpperCase()}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        firebaseService: firebaseService,
                        currentUser: currentUser,
                        chatUser: user,
                        geminiService: geminiService,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

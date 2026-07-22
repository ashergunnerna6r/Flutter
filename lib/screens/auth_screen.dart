import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/user_profile.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  final FirebaseService firebaseService;

  const AuthScreen({Key? key, required this.firebaseService}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isRegistering = false;
  bool isLoading = false;
  String errorMsg = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  String _selectedLang = 'en';

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English 🇺🇸'},
    {'code': 'es', 'name': 'Spanish 🇪🇸'},
    {'code': 'fr', 'name': 'French 🇫🇷'},
    {'code': 'de', 'name': 'German 🇩🇪'},
    {'code': 'bn', 'name': 'Bengali 🇧🇩'},
    {'code': 'ja', 'name': 'Japanese 🇯🇵'},
  ];

  Future<void> _handleSubmit() async {
    setState(() {
      isLoading = true;
      errorMsg = '';
    });

    try {
      UserProfile? user;
      if (isRegistering) {
        user = await widget.firebaseService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          preferredLanguage: _selectedLang,
        );
      } else {
        user = await widget.firebaseService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              firebaseService: widget.firebaseService,
              currentUser: user!,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.public, color: Color(0xFF6366F1), size: 32),
                ),
                const SizedBox(height: 16),
                const Text(
                  'LingoChat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI Real-time Translation Chat',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => setState(() => isRegistering = false),
                        style: TextButton.styleFrom(
                          foregroundColor: !isRegistering ? const Color(0xFF6366F1) : Colors.grey,
                        ),
                        child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => setState(() => isRegistering = true),
                        style: TextButton.styleFrom(
                          foregroundColor: isRegistering ? const Color(0xFF6366F1) : Colors.grey,
                        ),
                        child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (errorMsg.isNotEmpty) ...[
                  Text(errorMsg, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  const SizedBox(height: 12),
                ],
                if (isRegistering) ...[
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.alternate_email, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isRegistering ? 'Create Account' : 'Sign In',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

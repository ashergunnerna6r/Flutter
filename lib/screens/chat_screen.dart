import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/user_profile.dart';
import '../services/firebase_service.dart';
import '../services/gemini_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  final UserProfile currentUser;
  final UserProfile chatUser;
  final GeminiService geminiService;

  const ChatScreen({
    Key? key,
    required this.firebaseService,
    required this.currentUser,
    required this.chatUser,
    required this.geminiService,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgController = TextEditingController();
  bool _isSending = false;

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    _msgController.clear();
    setState(() => _isSending = true);

    // AI Translation using Gemini
    final translated = await widget.geminiService.translateText(
      text: text,
      targetLang: widget.chatUser.preferredLanguage,
    );

    final newMsg = ChatMessage(
      messageId: const Uuid().v4(),
      senderId: widget.currentUser.uid,
      receiverId: widget.chatUser.uid,
      originalText: text,
      translatedText: translated,
      sourceLanguage: widget.currentUser.preferredLanguage,
      targetLanguage: widget.chatUser.preferredLanguage,
      timestamp: DateTime.now().toIso8601String(),
      status: 'sent',
      emojiReactions: [],
    );

    await widget.firebaseService.sendMessage(newMsg);
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF6366F1),
              child: Text(
                widget.chatUser.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Text(
                  widget.chatUser.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  '@${widget.chatUser.username} • ${widget.chatUser.preferredLanguage.toUpperCase()}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: widget.firebaseService.getMessagesStream(widget.chatUser.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final msgs = snapshot.data!;
                return ListView.builder(
                  reverse: false,
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[index];
                    return MessageBubble(
                      message: m,
                      isMe: m.senderId == widget.currentUser.uid,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type message in your language...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF6366F1)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

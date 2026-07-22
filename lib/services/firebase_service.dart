import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/user_profile.dart';
import '../models/chat_message.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> initializeFCM() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _messaging.getToken();
        if (token != null && currentUser != null) {
          await _firestore.collection('users').doc(currentUser!.uid).update({
            'fcmToken': token,
          });
        }
      }
    } catch (e) {
      print('FCM Init Notice: $e');
    }
  }

  Future<UserProfile?> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required String preferredLanguage,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    UserProfile profile = UserProfile(
      uid: cred.user!.uid,
      name: name,
      username: username.toLowerCase().replaceAll('@', '').trim(),
      email: email,
      bio: 'Hey there! I am using LingoChat for AI real-time translation.',
      preferredLanguage: preferredLanguage,
      onlineStatus: true,
      lastSeen: DateTime.now().toIso8601String(),
      avatarBase64: '',
    );

    await _firestore.collection('users').doc(cred.user!.uid).set(profile.toMap());
    return profile;
  }

  Future<UserProfile?> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(cred.user!.uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> signOut() async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'onlineStatus': false,
        'lastSeen': DateTime.now().toIso8601String(),
      });
    }
    await _auth.signOut();
  }

  Stream<List<UserProfile>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ChatMessage>> getMessagesStream(String otherUserId) {
    String myUid = currentUser?.uid ?? '';
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [myUid, otherUserId])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .where((m) =>
              (m.senderId == myUid && m.receiverId == otherUserId) ||
              (m.senderId == otherUserId && m.receiverId == myUid))
          .toList();
    });
  }

  Future<void> sendMessage(ChatMessage message) async {
    await _firestore
        .collection('messages')
        .doc(message.messageId)
        .set(message.toMap());
  }

  Future<void> addReaction(String messageId, EmojiReaction reaction) async {
    DocumentReference ref = _firestore.collection('messages').doc(messageId);
    await ref.update({
      'emojiReactions': FieldValue.arrayUnion([reaction.toMap()]),
    });
  }
}

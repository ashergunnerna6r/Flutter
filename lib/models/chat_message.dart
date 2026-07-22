class EmojiReaction {
  final String emoji;
  final String userId;

  EmojiReaction({required this.emoji, required this.userId});

  factory EmojiReaction.fromMap(Map<String, dynamic> map) {
    return EmojiReaction(
      emoji: map['emoji'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'userId': userId,
    };
  }
}

class ChatMessage {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final String timestamp;
  final String status;
  final List<EmojiReaction> emojiReactions;
  final bool deletedForEveryone;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.timestamp,
    required this.status,
    required this.emojiReactions,
    this.deletedForEveryone = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      originalText: map['originalText'] ?? '',
      translatedText: map['translatedText'] ?? '',
      sourceLanguage: map['sourceLanguage'] ?? 'auto',
      targetLanguage: map['targetLanguage'] ?? 'en',
      timestamp: map['timestamp'] ?? DateTime.now().toIso8601String(),
      status: map['status'] ?? 'sent',
      emojiReactions: (map['emojiReactions'] as List<dynamic>?)
              ?.map((e) => EmojiReaction.fromMap(e))
              .toList() ??
          [],
      deletedForEveryone: map['deletedForEveryone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'originalText': originalText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'timestamp': timestamp,
      'status': status,
      'emojiReactions': emojiReactions.map((e) => e.toMap()).toList(),
      'deletedForEveryone': deletedForEveryone,
    };
  }
}

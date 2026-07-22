class UserProfile {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String bio;
  final String preferredLanguage;
  final bool onlineStatus;
  final String lastSeen;
  final String avatarBase64;

  UserProfile({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.preferredLanguage,
    required this.onlineStatus,
    required this.lastSeen,
    required this.avatarBase64,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      onlineStatus: map['onlineStatus'] ?? false,
      lastSeen: map['lastSeen'] ?? DateTime.now().toIso8601String(),
      avatarBase64: map['avatarBase64'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'preferredLanguage': preferredLanguage,
      'onlineStatus': onlineStatus,
      'lastSeen': lastSeen,
      'avatarBase64': avatarBase64,
    };
  }
}

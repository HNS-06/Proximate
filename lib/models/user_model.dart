class UserProfile {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final List<String> interests;
  final String bio;
  final bool shareContact;
  final DateTime lastSeen;
  final List<String> connections;
  final List<String> skills;

  UserProfile({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    required this.interests,
    this.bio = '',
    this.shareContact = false,
    required this.lastSeen,
    this.connections = const [],
    this.skills = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'interests': interests,
      'bio': bio,
      'shareContact': shareContact,
      'lastSeen': lastSeen.toIso8601String(),
      'connections': connections,
      'skills': skills,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      interests: List<String>.from(map['interests']),
      bio: map['bio'] ?? '',
      shareContact: map['shareContact'] ?? false,
      lastSeen: DateTime.parse(map['lastSeen']),
      connections: List<String>.from(map['connections'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
    );
  }

  UserProfile copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    List<String>? interests,
    String? bio,
    bool? shareContact,
    DateTime? lastSeen,
    List<String>? connections,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      shareContact: shareContact ?? this.shareContact,
      lastSeen: lastSeen ?? this.lastSeen,
      connections: connections ?? this.connections,
    );
  }
}
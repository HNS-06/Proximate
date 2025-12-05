class Team {
  final String id;
  final String name;
  final String description;
  String leaderId;
  List<String> members;
  final int maxSize;
  final List<String> skillsNeeded;
  String? projectIdea;
  bool lookingForMembers;
  DateTime createdAt;
  DateTime? updatedAt;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderId,
    required this.members,
    this.maxSize = 4,
    this.skillsNeeded = const [],
    this.projectIdea,
    this.lookingForMembers = true,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get availableSpots => maxSize - members.length;
  double get fillPercentage => (members.length / maxSize) * 100;
  bool get isFull => members.length >= maxSize;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leaderId': leaderId,
      'members': members,
      'maxSize': maxSize,
      'skillsNeeded': skillsNeeded,
      'projectIdea': projectIdea,
      'lookingForMembers': lookingForMembers,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      leaderId: map['leaderId'],
      members: List<String>.from(map['members']),
      maxSize: map['maxSize'] ?? 4,
      skillsNeeded: List<String>.from(map['skillsNeeded'] ?? []),
      projectIdea: map['projectIdea'],
      lookingForMembers: map['lookingForMembers'] ?? true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}

class TeamInvite {
  final String id;
  final String teamId;
  final String userId;
  final String invitedById;
  InviteStatus status;
  final DateTime sentAt;
  DateTime? respondedAt;

  TeamInvite({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.invitedById,
    this.status = InviteStatus.pending,
    required this.sentAt,
    this.respondedAt,
  });
}

enum InviteStatus {
  pending,
  accepted,
  rejected,
  expired,
}

class TeamMessage {
  final String id;
  final String teamId;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final MessageType type;

  TeamMessage({
    required this.id,
    required this.teamId,
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  system,
  join,
  leave,
}
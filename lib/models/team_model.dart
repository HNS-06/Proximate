class Team {
  final String? id;
  final String name;
  final List<String> members;
  final String? lead;
  final String? leaderId;
  final bool lookingForMembers;
  final List<String> skillsNeeded;
  final String? projectName;
  final String? bio;
  final String? description;
  final int? maxSize;
  final String? projectIdea;

  Team({
    this.id,
    required this.name,
    required this.members,
    this.lead,
    this.leaderId,
    this.lookingForMembers = false,
    this.skillsNeeded = const [],
    this.projectName,
    this.bio,
    this.description,
    this.maxSize,
    this.projectIdea,
  });

  bool get isFull => maxSize != null && members.length >= maxSize!;
  
  double get fillPercentage => maxSize != null && maxSize! > 0 
    ? (members.length / maxSize!).clamp(0.0, 1.0)
    : 1.0;
  
  int get availableSpots => maxSize != null ? (maxSize! - members.length).clamp(0, maxSize!) : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'lead': lead,
      'leaderId': leaderId,
      'lookingForMembers': lookingForMembers,
      'skillsNeeded': skillsNeeded,
      'projectName': projectName,
      'bio': bio,
      'description': description,
      'maxSize': maxSize,
      'projectIdea': projectIdea,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      members: List<String>.from(map['members'] ?? []),
      lead: map['lead'],
      leaderId: map['leaderId'],
      lookingForMembers: map['lookingForMembers'] ?? false,
      skillsNeeded: List<String>.from(map['skillsNeeded'] ?? []),
      projectName: map['projectName'],
      bio: map['bio'],
      description: map['description'],
      maxSize: map['maxSize'],
      projectIdea: map['projectIdea'],
    );
  }
}

class TeamInvite {
  final String? id;
  final String teamId;
  final String userId;
  final InviteStatus status;
  final DateTime createdAt;
  final String? invitedById;
  final DateTime? sentAt;

  TeamInvite({
    this.id,
    required this.teamId,
    required this.userId,
    this.status = InviteStatus.pending,
    required this.createdAt,
    this.invitedById,
    this.sentAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamId': teamId,
      'userId': userId,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'invitedById': invitedById,
      'sentAt': sentAt?.toIso8601String(),
    };
  }

  factory TeamInvite.fromMap(Map<String, dynamic> map) {
    return TeamInvite(
      id: map['id'],
      teamId: map['teamId'],
      userId: map['userId'],
      status: _statusFromString(map['status'] ?? 'pending'),
      createdAt: DateTime.parse(map['createdAt']),
      invitedById: map['invitedById'],
      sentAt: map['sentAt'] != null ? DateTime.parse(map['sentAt']) : null,
    );
  }
}

enum InviteStatus { pending, accepted, rejected }

InviteStatus _statusFromString(String value) {
  switch (value) {
    case 'accepted':
      return InviteStatus.accepted;
    case 'rejected':
      return InviteStatus.rejected;
    default:
      return InviteStatus.pending;
  }
}

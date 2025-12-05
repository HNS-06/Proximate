class HackathonEvent {
  final String id;
  final String name;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<String> technologies;
  final String? website;
  final List<String> tags;
  final int participants;
  final bool isVirtual;

  HackathonEvent({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.technologies = const [],
    this.website,
    this.tags = const [],
    this.participants = 0,
    this.isVirtual = false,
  });

  int get daysUntilStart {
    final now = DateTime.now();
    return startDate.difference(now).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'technologies': technologies,
      'website': website,
      'tags': tags,
      'participants': participants,
      'isVirtual': isVirtual,
    };
  }

  factory HackathonEvent.fromMap(Map<String, dynamic> map) {
    return HackathonEvent(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      description: map['description'],
      technologies: List<String>.from(map['technologies'] ?? []),
      website: map['website'],
      tags: List<String>.from(map['tags'] ?? []),
      participants: map['participants'] ?? 0,
      isVirtual: map['isVirtual'] ?? false,
    );
  }
}

class HackathonEvent {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String website;
  final List<String> tags;
  final int participants;
  final String? organizer;
  final List<String>? sponsors;
  final List<EventPrize>? prizes;
  final List<EventSchedule>? schedule;

  HackathonEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.website,
    required this.tags,
    required this.participants,
    this.organizer,
    this.sponsors,
    this.prizes,
    this.schedule,
  });

  bool get isVirtual => location.toLowerCase().contains('virtual');
  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isOngoing => 
      startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());
      
  int get daysUntilStart => startDate.difference(DateTime.now()).inDays;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'website': website,
      'tags': tags,
      'participants': participants,
      'organizer': organizer,
      'sponsors': sponsors,
      'prizes': prizes?.map((p) => p.toMap()).toList(),
      'schedule': schedule?.map((s) => s.toMap()).toList(),
    };
  }
}

class EventPrize {
  final String place;
  final String prize;
  final String? description;

  EventPrize({
    required this.place,
    required this.prize,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'place': place,
      'prize': prize,
      'description': description,
    };
  }
}

class EventSchedule {
  final String time;
  final String event;
  final String? speaker;
  final String? location;

  EventSchedule({
    required this.time,
    required this.event,
    this.speaker,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'event': event,
      'speaker': speaker,
      'location': location,
    };
  }
}

class EventRegistration {
  final String id;
  final String eventId;
  final String userId;
  final DateTime registeredAt;
  final RegistrationStatus status;
  final String? teamId;

  EventRegistration({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.registeredAt,
    this.status = RegistrationStatus.pending,
    this.teamId,
  });
}

enum RegistrationStatus {
  pending,
  confirmed,
  checkedIn,
  cancelled,
}
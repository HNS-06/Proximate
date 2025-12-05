import '../../models/event_model.dart';

class EventApiService {
  static const String DEVPOST_API = 'https://devpost.com/api';
  static const String MLH_API = 'https://mlh.io';
  
  Future<List<HackathonEvent>> fetchUpcomingHackathons() async {
    // Mock data - in real app, integrate with actual APIs
    return [
      HackathonEvent(
        id: 'hack1',
        name: 'Global Hack Week',
        description: 'Worldwide virtual hackathon',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        location: 'Virtual',
        website: 'https://ghw.mlh.io',
        tags: ['Beginner Friendly', 'Workshops', 'Prizes'],
        participants: 5000,
      ),
      HackathonEvent(
        id: 'hack2',
        name: 'Flutter Hack',
        description: 'Flutter-only hackathon',
        startDate: DateTime.now().add(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        location: 'San Francisco, CA',
        website: 'https://flutterhack.dev',
        tags: ['Flutter', 'Dart', 'Mobile'],
        participants: 1200,
      ),
      HackathonEvent(
        id: 'hack3',
        name: 'AI Builders Summit',
        description: 'AI/ML focused hackathon',
        startDate: DateTime.now().add(const Duration(days: 14)),
        endDate: DateTime.now().add(const Duration(days: 21)),
        location: 'New York, NY',
        website: 'https://aibuilders.dev',
        tags: ['AI', 'ML', 'Neural Networks'],
        participants: 3000,
      ),
    ];
  }

  Future<List<HackathonEvent>> fetchEventsByLocation(double lat, double lng) async {
    // Mock location-based events
    return [
      HackathonEvent(
        id: 'local1',
        name: 'Local Tech Fest',
        description: 'Community tech festival',
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        location: 'Near You',
        website: 'https://localtech.dev',
        tags: ['Local', 'Community', 'Networking'],
        participants: 500,
      ),
    ];
  }

  Future<Map<String, dynamic>> getEventDetails(String eventId) async {
    // Mock event details
    return {
      'id': eventId,
      'name': 'Sample Hackathon',
      'description': 'Detailed description here',
      'schedule': [
        {'time': '10:00 AM', 'event': 'Opening Ceremony'},
        {'time': '11:00 AM', 'event': 'Team Formation'},
        {'time': '12:00 PM', 'event': 'Hacking Begins'},
      ],
      'prizes': [
        {'place': '1st', 'prize': '\$10,000'},
        {'place': '2nd', 'prize': '\$5,000'},
        {'place': '3rd', 'prize': '\$2,000'},
      ],
      'sponsors': ['Google', 'Microsoft', 'Amazon'],
      'challenges': [
        'Best Use of AI',
        'Best Mobile App',
        'Best Hardware Hack',
      ],
    };
  }

  Future<bool> registerForEvent(String eventId, String userId) async {
    // Mock registration
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<List<Map<String, dynamic>>> getEventParticipants(String eventId) async {
    // Mock participants
    return List.generate(10, (index) => {
      'id': 'user_$index',
      'name': 'Participant $index',
      'skills': ['Flutter', 'Firebase', 'AI'],
      'lookingForTeam': index % 2 == 0,
    });
  }
}
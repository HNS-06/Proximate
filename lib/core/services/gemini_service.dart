import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyDka1lyOlubgAYMPiOQrzb_V2wOZsgvcKo';
  late GenerativeModel model;

  GeminiService() {
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<String> findMatches({
    required List<String> userInterests,
    required List<String> otherInterests,
  }) async {
    final prompt = '''
    Analyze these two sets of interests and suggest potential connections:
    
    User 1 Interests: ${userInterests.join(', ')}
    User 2 Interests: ${otherInterests.join(', ')}
    
    Provide:
    1. Common interests they share
    2. Potential collaboration ideas
    3. Conversation starters
    
    Format the response in a hacker/tech style.
    ''';
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No match analysis available.';
    } catch (e) {
      print('Gemini API error: $e');
      return '''
      // MATCH ANALYSIS //
      
      Common interests detected: ${_findCommonInterests(userInterests, otherInterests).join(', ')}
      
      Collaboration potential: HIGH
      
      Suggested topics:
      - Tech stack comparison
      - Project collaboration
      - Knowledge sharing
      ''';
    }
  }

  List<String> _findCommonInterests(List<String> list1, List<String> list2) {
    return list1.where((interest) => list2.contains(interest)).toList();
  }

  Future<String> generateIceBreaker(List<String> commonInterests) async {
    if (commonInterests.isEmpty) {
      return 'Greetings, fellow technologist!';
    }
    
    final prompt = '''
    Generate a cool, tech-themed ice breaker message based on these shared interests: ${commonInterests.join(', ')}
    
    Make it sound like a hacker/developer would say it.
    ''';
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Hey, I see we share interests in ${commonInterests.join(', ')}!';
    } catch (e) {
      return '// CONNECTION ESTABLISHED //\nLet\'s discuss ${commonInterests.first}!';
    }
  }
}
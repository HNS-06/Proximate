import 'package:flutter/material.dart';

/// Matches screen showing nearby people matches
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final List<Map<String, dynamic>> matches = [
    {'name': 'User 1', 'interests': ['Flutter', 'AI'], 'distance': '50m'},
    {'name': 'User 2', 'interests': ['Dart', 'Web'], 'distance': '100m'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches', style: TextStyle(fontFamily: 'Monospace')),
      ),
      body: matches.isEmpty
          ? Center(
              child: Text(
                'No matches found\nStart scanning to find nearby users',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.withOpacity(0.7),
                  fontFamily: 'Monospace',
                ),
              ),
            )
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  color: Colors.black87,
                  child: ListTile(
                    title: Text(
                      match['name'],
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'Monospace',
                      ),
                    ),
                    subtitle: Text(
                      'Interests: ${match['interests'].join(", ")}\nDistance: ${match['distance']}',
                      style: TextStyle(color: Colors.green.withOpacity(0.7)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.green),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
    );
  }
}

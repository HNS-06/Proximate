import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final double distance;
  final List<String> interests;
  final VoidCallback onConnect;
  
  const ProfileCard({
    super.key,
    required this.name,
    required this.distance,
    required this.interests,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.2),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Center(
                child: Text(
                  name.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Profile Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  
                  const SizedBox(height: 5),
                  
                  Text(
                    '${distance.toStringAsFixed(1)}m away',
                    style: TextStyle(
                      color: Colors.green.withOpacity(0.7),
                      fontFamily: 'Monospace',
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Interests
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.take(3).map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.withOpacity(0.5)),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontFamily: 'Monospace',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // Connect Button
            IconButton(
              onPressed: onConnect,
              icon: const Icon(Icons.connect_without_contact, color: Colors.green),
              tooltip: 'Connect',
            ),
          ],
        ),
      ),
    );
  }
}
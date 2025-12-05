import 'package:flutter/material.dart';
import '../models/team_model.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  final VoidCallback onJoin;
  final VoidCallback onView;
  
  const TeamCard({
    super.key,
    required this.team,
    required this.onJoin,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final fillPercentage = team.fillPercentage;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    team.name,
                    style: const TextStyle(
                      fontFamily: 'Monospace',
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (team.lookingForMembers)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      'LOOKING',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            Text(
              team.description ?? 'No description provided',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.blue.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 15),
            
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Team Capacity:',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${team.members.length}/${team.maxSize}',
                      style: const TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 8,
                      width: (fillPercentage / 100) * (MediaQuery.of(context).size.width - 80),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            
            // Skills Needed
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: team.skillsNeeded.take(3).map((skill) {
                return Chip(
                  label: Text(
                    skill,
                    style: const TextStyle(
                      fontFamily: 'Monospace',
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.blue),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 15),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.visibility, color: Colors.blue, size: 18),
                    label: const Text(
                      'View Details',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (team.lookingForMembers && !team.isFull)
                  ElevatedButton.icon(
                    onPressed: onJoin,
                    icon: const Icon(Icons.group_add, color: Colors.blue, size: 18),
                    label: const Text(
                      'Join Team',
                      style: TextStyle(
                        fontFamily: 'Monospace',
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
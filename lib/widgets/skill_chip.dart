import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String skill;
  final bool selected;
  final VoidCallback onTap;
  
  const SkillChip({
    super.key,
    required this.skill,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.green : Colors.green.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              const Icon(
                Icons.check,
                color: Colors.black,
                size: 14,
              ),
            if (selected) const SizedBox(width: 5),
            Text(
              skill,
              style: TextStyle(
                fontFamily: 'Monospace',
                color: selected ? Colors.black : Colors.green,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
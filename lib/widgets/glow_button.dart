import 'package:flutter/material.dart';

/// Glow button widget with neon effect
class GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final double fontSize;

  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.green,
    this.fontSize = 16,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: widget.color, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontFamily: 'Monospace',
            color: widget.color,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

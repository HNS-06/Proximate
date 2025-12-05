import 'package:flutter/material.dart';

/// A terminal text widget that displays text character-by-character with typewriter effect.
class TerminalText extends StatefulWidget {
  final String text;
  final int speed; // Milliseconds per character (0 = instant)
  final Color color;

  const TerminalText({
    super.key,
    required this.text,
    this.speed = 50,
    this.color = Colors.green,
  });

  @override
  State<TerminalText> createState() => _TerminalTextState();
}

class _TerminalTextState extends State<TerminalText>
    with SingleTickerProviderStateMixin {
  late String _displayedText;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _displayedText = widget.speed == 0 ? widget.text : '';
    
    if (widget.speed > 0) {
      _controller = AnimationController(
        duration: Duration(
          milliseconds: widget.text.length * widget.speed,
        ),
        vsync: this,
      );

      _controller.addListener(() {
        int charCount =
            (widget.text.length * _controller.value).round();
        setState(() {
          _displayedText = widget.text.substring(0, charCount);
        });
      });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (widget.speed > 0) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: TextStyle(
        fontFamily: 'Monospace',
        color: widget.color,
        fontSize: 14,
        letterSpacing: 1,
      ),
    );
  }
}

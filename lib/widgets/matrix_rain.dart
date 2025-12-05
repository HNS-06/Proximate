import 'package:flutter/material.dart';
import 'dart:math';

class MatrixRainWidget extends StatefulWidget {
  const MatrixRainWidget({super.key});

  @override
  _MatrixRainWidgetState createState() => _MatrixRainWidgetState();
}

class _MatrixRainWidgetState extends State<MatrixRainWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<RainDrop> rainDrops = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _initRainDrops();
  }

  void _initRainDrops() {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      rainDrops.add(RainDrop(
        x: random.nextDouble(),
        speed: 1 + random.nextDouble() * 3,
        length: 5 + random.nextInt(20),
        startTime: random.nextDouble() * 2,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MatrixRainPainter(
            time: _controller.value,
            rainDrops: rainDrops,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RainDrop {
  final double x;
  final double speed;
  final int length;
  final double startTime;

  RainDrop({
    required this.x,
    required this.speed,
    required this.length,
    required this.startTime,
  });
}

class MatrixRainPainter extends CustomPainter {
  final double time;
  final List<RainDrop> rainDrops;

  MatrixRainPainter({required this.time, required this.rainDrops});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    
    final random = Random();

    for (var drop in rainDrops) {
      final y = (time * drop.speed + drop.startTime) % 1.0;
      final startY = size.height * y;
      
      for (int i = 0; i < drop.length; i++) {
        final segmentY = startY - i * 15;
        if (segmentY < 0) break;
        
        final opacity = 1.0 - (i / drop.length);
        paint.color = Colors.green.withOpacity(opacity * 0.8);
        
        final text = String.fromCharCode(0x30A0 + random.nextInt(96));
        final span = TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.green.withOpacity(opacity),
            fontSize: 20,
            fontFamily: 'Monospace',
          ),
        );
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        )..layout();
        
        tp.paint(
          canvas,
          Offset(
            size.width * drop.x,
            segmentY,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixRainPainter oldDelegate) {
    return true;
  }
}
import 'package:flutter/material.dart';
import 'dart:typed_data';

/// A hacker-themed background widget with glowing effects and scanlines.
class HackerBackground extends StatefulWidget {
  const HackerBackground({super.key});

  @override
  State<HackerBackground> createState() => _HackerBackgroundState();
}

class _HackerBackgroundState extends State<HackerBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Scanlines effect
            Opacity(
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ScanlinePattern.image(),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
            // Glowing top effect
            Positioned(
              top: -50,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1 + (0.1 * _controller.value),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.green.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Glowing bottom effect
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1 + (0.1 * (1 - _controller.value)),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.green.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Generates scanline pattern
class ScanlinePattern {
  static ImageProvider image() {
    const int width = 16;
    const int height = 2;
    final pixels = <int>[];

    for (int i = 0; i < width * height; i++) {
      pixels.add((i ~/ width) % 2 == 0 ? 0xFF000000 : 0x00000000);
    }

    return MemoryImage(
      _generatePatternImage(width, height, pixels),
    );
  }

  static Uint8List _generatePatternImage(
      int width, int height, List<int> pixels) {
    // RGBA format
    final rgbaPixels = <int>[];
    for (int pixel in pixels) {
      rgbaPixels.addAll([0, 255, 0, (pixel >> 24) & 0xFF]); // Green color
    }
    return Uint8List.fromList(rgbaPixels);
  }
}

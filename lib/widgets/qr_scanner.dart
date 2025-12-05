import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onScan;
  
  const QRScannerWidget({
    super.key,
    required this.onScan,
  });

  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Ensure camera preview has black background
      child: Stack(
        children: [
          // Camera Preview - Ensure it fills the entire container
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  widget.onScan(barcode.rawValue!);
                  setState(() => _isScanning = false);
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() => _isScanning = true);
                  });
                }
              }
            },
          ),
          
          // Scanner Overlay - FIXED
          ScannerOverlay(),
          
          // Center Guide - Made smaller and more precise
          Center(
            child: Container(
              width: 230, // Reduced from 250
              height: 230, // Reduced from 250
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.withOpacity(0.3), // More transparent
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 2,
                  width: _isScanning ? 180 : 0, // Reduced from 200
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.green.withOpacity(0.8), // More transparent
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Instructions - Made more visible but less obstructive
          Positioned(
            bottom: 20, // Moved lower
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3), // More transparent
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
                child: const Text(
                  'Align QR code within frame',
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                    fontSize: 11, // Smaller
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ScannerOverlayPainter(),
        );
      },
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5) // Reduced opacity
      ..style = PaintingStyle.fill;
    
    final center = size.center(Offset.zero);
    const scannerSize = 230.0; // Match the container size above
    
    // Draw the darkened overlay around scanner area
    final scannerRect = Rect.fromCenter(
      center: center,
      width: scannerSize,
      height: scannerSize,
    );

    // Draw overlay as four rectangles instead of one with hole
    // This is more reliable and avoids black box issues
    
    // Top rectangle
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, scannerRect.top), paint);
    
    // Left rectangle
    canvas.drawRect(
      Rect.fromLTRB(0, scannerRect.top, scannerRect.left, scannerRect.bottom),
      paint,
    );
    
    // Right rectangle
    canvas.drawRect(
      Rect.fromLTRB(scannerRect.right, scannerRect.top, size.width, scannerRect.bottom),
      paint,
    );
    
    // Bottom rectangle
    canvas.drawRect(
      Rect.fromLTRB(0, scannerRect.bottom, size.width, size.height),
      paint,
    );

    // Draw scanner border with rounded corners
    final borderPaint = Paint()
      ..color = Colors.green.withOpacity(0.6) // More transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw rounded rectangle border
    final borderRect = RRect.fromRectAndRadius(
      scannerRect,
      const Radius.circular(12),
    );
    canvas.drawRRect(borderRect, borderPaint);
    
    // Draw corner indicators
    const cornerLength = 15.0; // Smaller corners
    final cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    
    // Top-left corner
    canvas.drawLine(
      scannerRect.topLeft,
      scannerRect.topLeft + const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.topLeft,
      scannerRect.topLeft + const Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Top-right corner
    canvas.drawLine(
      scannerRect.topRight,
      scannerRect.topRight - const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.topRight,
      scannerRect.topRight + const Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Bottom-left corner
    canvas.drawLine(
      scannerRect.bottomLeft,
      scannerRect.bottomLeft + const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.bottomLeft,
      scannerRect.bottomLeft - const Offset(0, cornerLength),
      cornerPaint,
    );
    
    // Bottom-right corner
    canvas.drawLine(
      scannerRect.bottomRight,
      scannerRect.bottomRight - const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.bottomRight,
      scannerRect.bottomRight - const Offset(0, cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
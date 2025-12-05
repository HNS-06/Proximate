import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final double size;
  final Color color;
  
  const QRGeneratorWidget({
    super.key,
    required this.data,
    this.size = 200,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    final jsonString = _mapToJson(data);
    
    return Column(
      children: [
        QrImageView(
          data: jsonString,
          version: QrVersions.auto,
          size: size,
          backgroundColor: Colors.black,
          eyeStyle: QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: color,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                'Encrypted QR',
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  String _mapToJson(Map<String, dynamic> map) {
    // Simple JSON conversion
    final entries = map.entries.map((e) => '"${e.key}":"${e.value}"');
    return '{${entries.join(',')}}';
  }
}
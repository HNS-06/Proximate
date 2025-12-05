import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/user_model.dart';

class QRService extends GetxService {
  late MobileScannerController scannerController;
  final RxBool _isScanning = false.obs;
  final RxString _lastScannedData = ''.obs;

  Future<QRService> init() async {
    scannerController = MobileScannerController();
    return this;
  }

  QrImageView generateProfileQR(UserProfile profile, {double size = 200}) {
    final profileData = jsonEncode(profile.toMap());
    return QrImageView(
      data: profileData,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.black,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.green,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.green,
      ),
    );
  }

  QrImageView generateTeamQR(String teamId, String teamName, {double size = 200}) {
    final teamData = jsonEncode({
      'teamId': teamId,
      'teamName': teamName,
      'type': 'team_invite',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    return QrImageView(
      data: teamData,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.black,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.circle,
        color: Colors.blue,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Colors.blue,
      ),
    );
  }

  Future<String?> scanQR() async {
    _isScanning.value = true;
    
    try {
      await scannerController.start();
      // In real app, this would return the scanned data
      // For simulation, return mock data
      await Future.delayed(const Duration(seconds: 2));
      
      final mockData = jsonEncode({
        'userId': 'scanned_user_001',
        'name': 'Scanned User',
        'interests': ['Flutter', 'AI', 'Security'],
        'skills': ['Dart', 'Firebase', 'Bluetooth'],
      });
      
      _lastScannedData.value = mockData;
      return mockData;
    } catch (e) {
      print('QR Scan error: $e');
      return null;
    } finally {
      _isScanning.value = false;
      scannerController.stop();
    }
  }

  Future<Map<String, dynamic>?> parseQRData(String qrData) async {
    try {
      return jsonDecode(qrData) as Map<String, dynamic>;
    } catch (e) {
      print('QR Parse error: $e');
      return null;
    }
  }

  Future<void> shareViaQR(UserProfile profile) async {
    final qrData = jsonEncode({
      'type': 'profile_share',
      'data': profile.toMap(),
      'encrypted': true,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // In real app, this would save/share the QR image
    print('QR Data for sharing: $qrData');
  }

  bool get isScanning => _isScanning.value;
  String get lastScannedData => _lastScannedData.value;

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
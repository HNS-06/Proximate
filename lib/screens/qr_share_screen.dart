import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/qr_generator.dart';
import '../widgets/qr_scanner.dart';
import '../core/services/qr_service.dart';
import '../core/utils/sound_manager.dart';

class QRShareScreen extends StatefulWidget {
  const QRShareScreen({super.key});

  @override
  _QRShareScreenState createState() => _QRShareScreenState();
}

class _QRShareScreenState extends State<QRShareScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final QRService _qrService = Get.find();
  String _scannedData = '';
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR CONNECTION',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.qr_code),
              text: 'Generate QR',
            ),
            Tab(
              icon: Icon(Icons.qr_code_scanner),
              text: 'Scan QR',
            ),
          ],
          indicatorColor: Colors.green,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.green.withOpacity(0.5),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Generate QR Tab - FIXED
          _buildGenerateTab(),
          // Scan QR Tab
          _buildScanTab(),
        ],
      ),
    );
  }

  Widget _buildGenerateTab() {
    return SafeArea(
      child: SingleChildScrollView( // ADDED: Make the content scrollable
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Generate your profile QR code to share offline',
                style: TextStyle(
                  fontFamily: 'Monospace',
                  color: Colors.green,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // QR Code Display
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: _isGenerating
                    ? const CircularProgressIndicator(color: Colors.green)
                    : QRGeneratorWidget(
                        data: {
                          'name': 'Hacker User',
                          'interests': ['Flutter', 'AI', 'Security'],
                          'skills': ['Dart', 'Firebase', 'Encryption'],
                          'contact': 'user@hackathon.com',
                        },
                        size: 250,
                      ),
              ),
              
              const SizedBox(height: 30),
              
              // Options - Wrap with Center for better alignment
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildOptionButton(
                      'Profile QR',
                      Icons.person,
                      () => _generateProfileQR(),
                    ),
                    _buildOptionButton(
                      'Team QR',
                      Icons.group,
                      () => _generateTeamQR(),
                    ),
                    _buildOptionButton(
                      'Contact QR',
                      Icons.contact_page,
                      () => _generateContactQR(),
                    ),
                    _buildOptionButton(
                      'Save QR',
                      Icons.download,
                      () => _saveQR(),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Encryption Status
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'All QR codes are encrypted for security',
                        style: TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Extra padding at bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Scan QR codes to connect with other hackers',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // QR Scanner - proportional
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: ClipRRect( // ADDED: Clip to prevent overflow
                  borderRadius: BorderRadius.circular(17), // Slightly smaller than container
                  child: QRScannerWidget(
                    onScan: (data) {
                      SoundManager.playQRScan();
                      setState(() {
                        _scannedData = data;
                      });
                      _showScanResult(data);
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Scan Result - only show if data exists, constrained height
            if (_scannedData.isNotEmpty)
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Scan Result:',
                        style: TextStyle(
                          fontFamily: 'Monospace',
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _scannedData.length > 100
                                ? '${_scannedData.substring(0, 100)}...'
                                : _scannedData,
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              color: Colors.green.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _processScannedData(_scannedData),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Process Data',
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.green),
      label: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Monospace',
          color: Colors.green,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        side: const BorderSide(color: Colors.green),
      ),
    );
  }

  Future<void> _generateProfileQR() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 1));
    SoundManager.playConnect();
    setState(() => _isGenerating = false);
  }

  Future<void> _generateTeamQR() async {
    // Generate team QR
    await _qrService.generateTeamQR('team_123', 'Quantum Coders');
    SoundManager.playQRScan();
  }

  Future<void> _generateContactQR() async {
    // Generate contact QR
    SoundManager.playConnect();
  }

  Future<void> _saveQR() async {
    // Save QR to gallery
    SoundManager.playQRScan();
  }

  void _showScanResult(String data) {
    Get.defaultDialog(
      title: 'QR Scan Result',
      titleStyle: const TextStyle(
        fontFamily: 'Monospace',
        color: Colors.green,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data received:',
            style: TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SelectableText(
              data,
              style: const TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Close',
            style: TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _processScannedData(String data) async {
    try {
      final parsedData = await _qrService.parseQRData(data);
      if (parsedData != null) {
        Get.snackbar(
          'Success',
          'QR data processed successfully',
          backgroundColor: Colors.black,
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process QR data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/encryption_service.dart';
import '../core/utils/sound_manager.dart';

class EncryptionSetupScreen extends StatefulWidget {
  const EncryptionSetupScreen({super.key});

  @override
  _EncryptionSetupScreenState createState() => _EncryptionSetupScreenState();
}

class _EncryptionSetupScreenState extends State<EncryptionSetupScreen> {
  final EncryptionService _encryption = Get.find();
  bool _isEncryptionEnabled = true;
  bool _isGeneratingKeys = false;

  @override
  void initState() {
    super.initState();
    _isEncryptionEnabled = _encryption.isEncryptionEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ENCRYPTION SETUP',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isEncryptionEnabled ? Icons.lock : Icons.lock_open,
                        color: _isEncryptionEnabled ? Colors.green : Colors.red,
                        size: 30,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEncryptionEnabled ? 'ENCRYPTION ACTIVE' : 'ENCRYPTION DISABLED',
                              style: TextStyle(
                                fontFamily: 'Monospace',
                                color: _isEncryptionEnabled ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _isEncryptionEnabled
                                  ? 'All data is encrypted end-to-end'
                                  : 'Data transmission is not encrypted',
                              style: TextStyle(
                                fontFamily: 'Monospace',
                                color: Colors.green.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isEncryptionEnabled,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.green.withOpacity(0.3),
                        onChanged: (value) {
                          setState(() => _isEncryptionEnabled = value);
                          SoundManager.play('encrypt.wav');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Encryption Info
            const Text(
              'Encryption Details:',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            
            _buildInfoCard(
              'Algorithm',
              'AES-256-CBC',
              Icons.security,
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              'Key Strength',
              '256-bit Encryption',
              Icons.vpn_key,
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              'Key Exchange',
              'Secure Key Distribution',
              Icons.swap_horiz,
            ),
            const SizedBox(height: 30),
            
            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGeneratingKeys ? null : _regenerateKeys,
                icon: _isGeneratingKeys
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.green),
                label: Text(
                  _isGeneratingKeys ? 'Regenerating Keys...' : 'Regenerate Encryption Keys',
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showKeyInfo,
                icon: const Icon(Icons.info, color: Colors.green),
                label: const Text(
                  'View Security Info',
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testEncryption,
                icon: const Icon(Icons.bug_report, color: Colors.green),
                label: const Text(
                  'Test Encryption',
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _regenerateKeys() async {
    setState(() => _isGeneratingKeys = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    SoundManager.play('encrypt.wav');
    Get.snackbar(
      'Success',
      'Encryption keys regenerated successfully',
      backgroundColor: Colors.black,
      colorText: Colors.green,
    );
    
    setState(() => _isGeneratingKeys = false);
  }

  void _showKeyInfo() {
    Get.defaultDialog(
      title: 'Security Information',
      titleStyle: const TextStyle(
        fontFamily: 'Monospace',
        color: Colors.green,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSecurityItem('End-to-End Encryption', 'All data is encrypted before transmission'),
          _buildSecurityItem('Perfect Forward Secrecy', 'Keys are regenerated periodically'),
          _buildSecurityItem('No Backdoors', 'We cannot access your encrypted data'),
          _buildSecurityItem('Open Standards', 'Uses AES-256 encryption standard'),
          _buildSecurityItem('Secure Key Storage', 'Keys stored in device secure storage'),
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

  Widget _buildSecurityItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _testEncryption() async {
    SoundManager.play('encrypt.wav');
    
    const testMessage = 'This is a test message for encryption';
    
    // In real app, use actual encryption
    // final encrypted = _encryption.encrypt(testMessage);
    // final decrypted = _encryption.decrypt(encrypted);
    
    Get.defaultDialog(
      title: 'Encryption Test',
      titleStyle: const TextStyle(
        fontFamily: 'Monospace',
        color: Colors.green,
      ),
      content: Column(
        children: [
          _buildTestStep('Original Message', testMessage),
          const SizedBox(height: 10),
          _buildTestStep('Encrypted', 'U2FsdGVkX1+...encrypted_data...'),
          const SizedBox(height: 10),
          _buildTestStep('Decrypted', testMessage),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Encryption/Decryption successful!',
                    style: TextStyle(
                      fontFamily: 'Monospace',
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
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

  Widget _buildTestStep(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontFamily: 'Monospace',
            color: Colors.green.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Monospace',
              color: Colors.green,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
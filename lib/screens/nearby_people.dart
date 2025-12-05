import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_card.dart';
import '../widgets/terminal_text.dart';
import '../core/services/bluetooth_service.dart';
import '../core/utils/sound_manager.dart';

class NearbyPeopleScreen extends StatefulWidget {
  const NearbyPeopleScreen({super.key});

  @override
  _NearbyPeopleScreenState createState() => _NearbyPeopleScreenState();
}

class _NearbyPeopleScreenState extends State<NearbyPeopleScreen> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothService>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const TerminalText(
              text: '>> PROXIMATE SCANNER <<',
              speed: 0,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text(
              'Detecting users within Bluetooth range...',
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green.withOpacity(0.7),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            // Stats Cards
            Row(
              children: [
                _buildStatCard('ACTIVE USERS', '${bluetoothService.scanResults.length}', Icons.people),
                const SizedBox(width: 10),
                _buildStatCard('RANGE', '50m', Icons.radar),
                const SizedBox(width: 10),
                _buildStatCard('MATCHES', '3', Icons.connected_tv),
              ],
            ),

            const SizedBox(height: 30),

            // Scan Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (!_isScanning) {
                    setState(() => _isScanning = true);
                    // start continuous scan (no timeout) - UI won't be blocked
                    bluetoothService.startScan();
                  } else {
                    // stop an ongoing scan
                    bluetoothService.stopScan();
                    setState(() => _isScanning = false);
                  }
                },
                icon: _isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      )
                    : const Icon(Icons.search, color: Colors.green),
                label: Text(
                  _isScanning ? 'SCANNING...' : 'START SCAN',
                  style: const TextStyle(
                    fontFamily: 'Monospace',
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Nearby People List
            Expanded(
              child: bluetoothService.scanResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: Colors.green.withOpacity(0.5),
                            size: 60,
                          ),
                          const SizedBox(height: 20),
                          const TerminalText(
                            text: 'NO USERS DETECTED',
                            speed: 0,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Start scanning to find nearby people',
                            style: TextStyle(
                              color: Colors.green.withOpacity(0.7),
                              fontFamily: 'Monospace',
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: bluetoothService.scanResults.length,
                      itemBuilder: (context, index) {
                        final device = bluetoothService.scanResults[index].device;
                        // Generate simulated data based on device
                        final distance = 50.0 + index * 20.0;
                        final interests = ['Flutter', 'AI', 'Security'];

                        return ProfileCard(
                          name: device.platformName,
                          distance: distance,
                          interests: interests,
                          onConnect: () {
                            SoundManager.play('connect.wav');
                            // Connect to this user
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Monospace',
                color: Colors.green.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
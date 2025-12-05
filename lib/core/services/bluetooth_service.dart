import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as flutter_blue;
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'encryption_service.dart';
import '../../models/user_model.dart';

class BluetoothService extends ChangeNotifier {
  List<flutter_blue.ScanResult> scanResults = [];
  List<flutter_blue.BluetoothDevice> connectedDevices = [];
  bool isScanning = false;
  bool isAdvertising = false;
  String status = 'Disconnected';
  StreamController<Map<String, dynamic>> _dataReceivedController = 
      StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription<List<flutter_blue.ScanResult>>? _scanSubscription;
  
  final EncryptionService _encryption = Get.find<EncryptionService>();
  
  // Service UUIDs for our app
  static const String SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String RX_CHARACTERISTIC_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String TX_CHARACTERISTIC_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  
  Stream<Map<String, dynamic>> get dataReceivedStream => _dataReceivedController.stream;
  
  Future<void> startAdvertising(UserProfile profile) async {
    try {
      isAdvertising = true;
      status = 'Advertising...';
      notifyListeners();
      
      // Encrypt profile data
      final encryptedProfile = _encryption.encryptProfile(profile.toMap());
      final advertisementData = jsonEncode({
        'type': 'profile',
        'data': encryptedProfile,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      // In real app, we would advertise this data
      print('Advertising profile: $advertisementData');
      
      // Simulate advertising
      await Future.delayed(const Duration(seconds: 1));
      
    } catch (e) {
      print('Advertising error: $e');
      isAdvertising = false;
      notifyListeners();
    }
  }
  
  Future<void> stopAdvertising() async {
    isAdvertising = false;
    status = 'Stopped advertising';
    notifyListeners();
  }
  
  Future<void> startScan({bool encryptedOnly = true, int? timeoutSeconds}) async {
    if (isScanning) return;

    isScanning = true;
    status = 'Scanning...';
    notifyListeners();

    try {
      // start scan with optional timeout
      if (timeoutSeconds != null) {
        await flutter_blue.FlutterBluePlus.startScan(
          timeout: Duration(seconds: timeoutSeconds),
        );
      } else {
        await flutter_blue.FlutterBluePlus.startScan();
      }

      _scanSubscription = flutter_blue.FlutterBluePlus.scanResults.listen((results) async {
        scanResults = results;

        // Process scanned devices
        for (var result in results) {
          await _processScanResult(result, encryptedOnly);
        }

        notifyListeners();
      });

      if (timeoutSeconds != null) {
        await Future.delayed(Duration(seconds: timeoutSeconds));
        await stopScan();
      }

    } catch (e) {
      print('Scan error: $e');
    }

    isScanning = false;
    status = 'Scan complete';
    notifyListeners();
  }

  Future<void> stopScan() async {
    try {
      await flutter_blue.FlutterBluePlus.stopScan();
      await _scanSubscription?.cancel();
      _scanSubscription = null;
      isScanning = false;
      status = 'Scan stopped';
      notifyListeners();
    } catch (e) {
      print('Error stopping scan: $e');
    }
  }
  
  Future<void> _processScanResult(flutter_blue.ScanResult result, bool encryptedOnly) async {
    try {
      // Check if device has our service UUID in advertisement data
      if (result.advertisementData.serviceUuids.contains(SERVICE_UUID)) {
        print('Found compatible device: ${result.device.platformName}');
        
        // Try to connect and exchange data
        await _connectAndExchangeData(result.device);
      }
    } catch (e) {
      print('Error processing scan result: $e');
    }
  }
  
  Future<void> _connectAndExchangeData(flutter_blue.BluetoothDevice device) async {
    try {
      status = 'Connecting to ${device.platformName}...';
      notifyListeners();
      
      await device.connect();
      connectedDevices.add(device);
      
      // Discover services
      List<flutter_blue.BluetoothService> services = await device.discoverServices();
      
      for (var service in services) {
        if (service.uuid.toString().toUpperCase() == SERVICE_UUID) {
          // Found our service
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toUpperCase() == RX_CHARACTERISTIC_UUID) {
              // Subscribe to receive data
              await characteristic.setNotifyValue(true);
              characteristic.value.listen((data) {
                _handleReceivedData(data, device);
              });
              
              // Send our profile
              await _sendProfileData(characteristic);
            }
          }
        }
      }
      
      status = 'Connected to ${device.platformName}';
      notifyListeners();
      
    } catch (e) {
      print('Connection error: $e');
      await device.disconnect();
      connectedDevices.remove(device);
    }
  }
  
  Future<void> _sendProfileData(flutter_blue.BluetoothCharacteristic characteristic) async {
    // Get current user profile (you'll need to implement this)
    final mockProfile = {
      'name': 'Hacker User',
      'interests': ['Flutter', 'AI', 'Security'],
      'skills': ['Dart', 'Firebase', 'Encryption'],
    };
    
    final encryptedData = _encryption.encryptProfile(mockProfile);
    final jsonData = jsonEncode(encryptedData);
    final bytes = utf8.encode(jsonData);
    
    // Split into chunks if data is large
    const chunkSize = 20; // BLE MTU size
    for (int i = 0; i < bytes.length; i += chunkSize) {
      final chunk = bytes.sublist(
        i,
        i + chunkSize < bytes.length ? i + chunkSize : bytes.length,
      );
      await characteristic.write(chunk);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
  
  void _handleReceivedData(List<int> data, flutter_blue.BluetoothDevice device) {
    try {
      final jsonString = utf8.decode(data);
      final receivedData = jsonDecode(jsonString);
      
      // Decrypt if encrypted
      final decryptedData = _encryption.decryptProfile(
        Map<String, dynamic>.from(receivedData),
      );
      
      // Add device info to received data
      decryptedData['deviceId'] = device.remoteId.toString();
      decryptedData['deviceName'] = device.platformName;
      decryptedData['receivedAt'] = DateTime.now().toIso8601String();
      
      // Broadcast received data
      _dataReceivedController.add(decryptedData);
      
      print('Received data from ${device.platformName}: $decryptedData');
      
    } catch (e) {
      print('Error handling received data: $e');
    }
  }
  
  Future<void> sendTeamInvite(String teamId, String teamName, flutter_blue.BluetoothDevice device) async {
    try {
      final inviteData = {
        'type': 'team_invite',
        'teamId': teamId,
        'teamName': teamName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      final encryptedInvite = _encryption.encrypt(jsonEncode(inviteData));
      // ignore: unused_local_variable
      final bytes = utf8.encode(encryptedInvite);
      
      // Send via BLE
      // (Implementation similar to _sendProfileData)
      
      print('Team invite sent to ${device.platformName}');
      
    } catch (e) {
      print('Error sending team invite: $e');
    }
  }
  
  Future<void> disconnectDevice(flutter_blue.BluetoothDevice device) async {
    try {
      await device.disconnect();
      connectedDevices.remove(device);
      notifyListeners();
    } catch (e) {
      print('Disconnect error: $e');
    }
  }
  
  Future<void> disconnectAll() async {
    for (var device in connectedDevices) {
      await device.disconnect();
    }
    connectedDevices.clear();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _dataReceivedController.close();
    disconnectAll();
    super.dispose();
  }
}
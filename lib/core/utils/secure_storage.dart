import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static Future<void> init() async {
    // Initialize secure storage
  }
  
  static Future<void> saveEncryptionKey(String key) async {
    await _storage.write(key: 'encryption_key', value: key);
  }
  
  static Future<String?> getEncryptionKey() async {
    return await _storage.read(key: 'encryption_key');
  }
  
  static Future<void> saveUserData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  static Future<String?> getUserData(String key) async {
    return await _storage.read(key: key);
  }
  
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
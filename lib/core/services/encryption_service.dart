import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  late encrypt_lib.Encrypter _encrypter;
  late encrypt_lib.IV _iv;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isEncryptionEnabled = false;

  Future<EncryptionService> init() async {
    await _loadOrGenerateKeys();
    return this;
  }

  Future<void> _loadOrGenerateKeys() async {
    String? keyString = await _storage.read(key: 'encryption_key');
    String? ivString = await _storage.read(key: 'encryption_iv');
    
    if (keyString == null || ivString == null) {
      // Generate new keys
      final key = encrypt_lib.Key.fromSecureRandom(32);
      _iv = encrypt_lib.IV.fromSecureRandom(16);
      
      // Save keys
      await _storage.write(key: 'encryption_key', value: base64.encode(key.bytes));
      await _storage.write(key: 'encryption_iv', value: base64.encode(_iv.bytes));
      
      _encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: encrypt_lib.AESMode.cbc));
    } else {
      // Load existing keys
      final key = encrypt_lib.Key.fromBase64(keyString);
      _iv = encrypt_lib.IV.fromBase64(ivString);
      _encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: encrypt_lib.AESMode.cbc));
    }
    
    _isEncryptionEnabled = true;
  }

  String encrypt(String plainText) {
    if (!_isEncryptionEnabled) return plainText;
    
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Encryption error: $e');
      return plainText;
    }
  }

  String decrypt(String encryptedText) {
    if (!_isEncryptionEnabled) return encryptedText;
    
    try {
      final encrypted = encrypt_lib.Encrypted.fromBase64(encryptedText);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return encryptedText;
    }
  }

  Map<String, dynamic> encryptProfile(Map<String, dynamic> profile) {
    final encryptedProfile = <String, dynamic>{};
    
    for (var entry in profile.entries) {
      if (entry.value is String) {
        encryptedProfile[entry.key] = encrypt(entry.value as String);
      } else if (entry.value is Map) {
        encryptedProfile[entry.key] = encryptProfile(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        final encryptedList = (entry.value as List).map((item) {
          if (item is String) return encrypt(item);
          if (item is Map) return encryptProfile(item as Map<String, dynamic>);
          return item;
        }).toList();
        encryptedProfile[entry.key] = encryptedList;
      } else {
        encryptedProfile[entry.key] = entry.value;
      }
    }
    
    return encryptedProfile;
  }

  Map<String, dynamic> decryptProfile(Map<String, dynamic> encryptedProfile) {
    final decryptedProfile = <String, dynamic>{};
    
    for (var entry in encryptedProfile.entries) {
      if (entry.value is String) {
        try {
          decryptedProfile[entry.key] = decrypt(entry.value as String);
        } catch (e) {
          decryptedProfile[entry.key] = entry.value;
        }
      } else if (entry.value is Map) {
        decryptedProfile[entry.key] = decryptProfile(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        final decryptedList = (entry.value as List).map((item) {
          if (item is String) {
            try {
              return decrypt(item);
            } catch (e) {
              return item;
            }
          }
          if (item is Map) return decryptProfile(item as Map<String, dynamic>);
          return item;
        }).toList();
        decryptedProfile[entry.key] = decryptedList;
      } else {
        decryptedProfile[entry.key] = entry.value;
      }
    }
    
    return decryptedProfile;
  }

  String generateSessionKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }

  bool get isEncryptionEnabled => _isEncryptionEnabled;
}
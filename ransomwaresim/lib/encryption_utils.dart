import 'dart:convert';

class EncryptionUtils {
  static String encrypt(String text) {
    // Simple base64 encoding for simulation
    return base64Encode(utf8.encode(text));
  }

  static String decrypt(String encryptedText) {
    try {
      return utf8.decode(base64Decode(encryptedText));
    } catch (e) {
      return 'Invalid encrypted text';
    }
  }
}
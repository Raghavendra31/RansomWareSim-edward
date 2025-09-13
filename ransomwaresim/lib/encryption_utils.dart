import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:developer' as developer;

class EncryptionUtils {
  // IMPORTANT: This is a hardcoded key for demonstration purposes only.
  // In a real application, you should never hardcode keys.
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // Must be 32 chars for AES-256
  static final _iv = encrypt.IV.fromLength(16); // IV for AES

  static String encryptText(String text) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);

    // Log the encryption process
    developer.log('--- ENCRYPTING ---');
    developer.log('Original Text: $text');
    developer.log('Encrypted (Base64): ${encrypted.base64}');
    developer.log('--------------------');

    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);

      // Log the decryption process
      developer.log('--- DECRYPTING ---');
      developer.log('Encrypted Text (Base64): $encryptedText');
      developer.log('Decrypted Text: $decrypted');
      developer.log('--------------------');

      return decrypted;
    } catch (e) {
      final errorMessage = 'Decryption failed for: $encryptedText';
      developer.log(errorMessage, error: e);
      return 'Decryption Error';
    }
  }
}

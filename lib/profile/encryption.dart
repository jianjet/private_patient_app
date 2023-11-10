import 'package:encrypt/encrypt.dart' as encrypt;


class AESEncryptionForPatientId {
  static final key = encrypt.Key.fromBase64('SndjV1o3ckNMYjUyNGE4UmpkSnVxTGp6djRyQnAwdlU=');
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  encryptMsg(String text) => encrypter.encrypt(text, iv: iv);

  decryptMsg(encrypt.Encrypted text) => encrypter.decrypt(text, iv: iv);

  getCode(String encoded) => encrypt.Encrypted.fromBase64(encoded);
}

class AESEncryptionForPatientHealthRecords {
  static final key = encrypt.Key.fromBase64('OGs5emllc3hlUU9kU09ZN0hlOE9mT1g2VE9lNDNhVk4=');
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  encryptMsg(String text) => encrypter.encrypt(text, iv: iv);

  decryptMsg(encrypt.Encrypted text) => encrypter.decrypt(text, iv: iv);

  getCode(String encoded) => encrypt.Encrypted.fromBase64(encoded);
}
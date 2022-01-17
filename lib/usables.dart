import 'package:openpgp/openpgp.dart';

void generate(String username, String email, String passphrase) async {
  var keyOptions = KeyOptions()..rsaBits = 1024;
  var keypair = await OpenPGP.generate(
      options: Options()
        ..name = username
        ..email = email
        ..passphrase = passphrase
        ..keyOptions = keyOptions);

  print(keypair.privateKey.toString());
  print(keypair.publicKey.toString());
}

void encrypt(String text, String publicKey) async {
  var result = await OpenPGP.encrypt(text, publicKey);
}

void decrypt(String encryptedText, String privateKey, String passphrase) async {
  var result = await OpenPGP.decrypt(encryptedText, privateKey, passphrase);
}

void sign(
    String text, String publicKey, String privateKey, String passphrase) async {
  var result = await OpenPGP.sign(text, publicKey, privateKey, passphrase);
}

void verify(String textSigned, String text, String publicKey) async {
  var result = OpenPGP.verify(textSigned, text, publicKey);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/widgets/button_widget.dart';
import 'package:flutter/services.dart';
import 'package:openpgp/openpgp.dart';
import '/models/shared_preferences.dart';

class DecryptScreen extends StatefulWidget {
  const DecryptScreen({Key? key}) : super(key: key);

  @override
  _DecryptScreenState createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  late TextEditingController passphraseController;
  late TextEditingController privateKeyController;
  late TextEditingController encryptedTextController;
  late TextEditingController decryptedTextController;
  String decryptionResult = '';
  String passphrase = '';

  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    passphraseController = TextEditingController();
    privateKeyController = TextEditingController();
    encryptedTextController = TextEditingController();
    decryptedTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passphraseController.dispose();
    privateKeyController.dispose();
    encryptedTextController.dispose();
    decryptedTextController.dispose();

    getPrivate();
    super.dispose();
  }

  void getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get()
        .then((value) {
      passphrase = (value.data()!['passphrase']);
    });

    // here you write the codes to input the data into firestore
  }

  void getPrivate() async {
    privateKeyController.text =
        await UserSharedPreference.getPrivateKey() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                minLines: 3,
                maxLines: 3,
                controller: privateKeyController,
                decoration: InputDecoration(
                  hintText: 'Enter Private key',
                  suffixIcon: Column(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            privateKeyController.clear();
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.paste),
                        onPressed: () async {
                          privateKeyController.text =
                              await UserSharedPreference.getPrivateKey() ?? '';
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 3,
                maxLines: 3,
                controller: encryptedTextController,
                decoration: InputDecoration(
                  hintText: 'Enter Encrypted text',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        encryptedTextController.clear();
                      }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              ButtonWidget(
                  onPress: () async {
                    getCurrentUser();
                    await OpenPGP.decrypt(encryptedTextController.text,
                            privateKeyController.text, passphrase)
                        .then((value) {
                      decryptionResult = value;
                      decryptedTextController.text = decryptionResult;
                    });
                  },
                  textName: 'DECRYPT'),
              const SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 3,
                maxLines: 10,
                controller: decryptedTextController,
                decoration: InputDecoration(
                  hintText: 'Decrypted Text',
                  suffixIcon: Column(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            decryptedTextController.clear();
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: decryptedTextController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Copied Successfully')));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

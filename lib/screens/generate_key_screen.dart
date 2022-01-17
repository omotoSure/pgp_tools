import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';
import '/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/shared_preferences.dart';

class GenerateKeyScreen extends StatefulWidget {
  GenerateKeyScreen({Key? key}) : super(key: key);

  @override
  State<GenerateKeyScreen> createState() => _GenerateKeyScreenState();
}

class _GenerateKeyScreenState extends State<GenerateKeyScreen> {
  TextEditingController privateController = TextEditingController();

  TextEditingController publicController = TextEditingController();

  String userName = '';

  String emailAddress = '';

  String passphrase = '';

  String privateKey = '';

  String publicKey = '';

  var _isLoading = false;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  saveKeypairToSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('publicKey', publicKey);
    prefs.setString('privateKey', privateKey);
  }

  retrievePrivateKeyFromSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? receivedPrivateKey = prefs.getString('privateKey');
    return receivedPrivateKey;
  }

  retrievePublicKeyFromSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? receivedPublicKey = prefs.getString('privateKey');
    return receivedPublicKey;
  }

  void getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get()
        .then((value) {
      userName = (value.data()!['email']);
      emailAddress = (value.data()!['email']);
      passphrase = (value.data()!['passphrase']);
    });

    // here you write the codes to input the data into firestore
  }

  void generate(String username, String email, String passphrase) async {
    var keyOptions = KeyOptions()..rsaBits = 1024;
    await OpenPGP.generate(
            options: Options()
              ..name = username
              ..email = email
              ..passphrase = passphrase
              ..keyOptions = keyOptions)
        .then((value) {
      privateKey = value.privateKey.toString();
      publicKey = value.publicKey.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              if (_isLoading) const CircularProgressIndicator(),
              if (!_isLoading)
                ButtonWidget(
                    textName: 'Generate',
                    onPress: () {
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        if (true) {
                          getCurrentUser();
                          generate(userName, emailAddress, passphrase);
                          privateController.text = privateKey;
                          publicController.text = publicKey;
                        }
                      } catch (err) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    'PGP Private Key',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    minLines: 3,
                    maxLines: 10,
                    controller: privateController,
                    decoration: InputDecoration(
                      suffixIcon: Column(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                privateController.clear();
                              }),
                          const SizedBox(
                            height: 5,
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: privateController.text));
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
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    'PGP Public Key',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    minLines: 3,
                    maxLines: 10,
                    controller: publicController,
                    decoration: InputDecoration(
                      hintText: '',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      suffixIcon: Column(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                publicController.clear();
                              }),
                          const SizedBox(
                            height: 5,
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: publicController.text));
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
              const SizedBox(
                height: 20,
              ),
              ButtonWidget(
                textName: 'Save',
                onPress: () async {
                  await UserSharedPreference.setPrivateKey(
                          privateController.text)
                      .then((value) {
                    Clipboard.setData(
                        const ClipboardData(text: 'Private Key saved'));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Private Key saved')));
                  });
                  await UserSharedPreference.setPublicKey(publicController.text)
                      .then((value) {
                    Clipboard.setData(
                        const ClipboardData(text: 'Public Key saved'));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Public Key saved')));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

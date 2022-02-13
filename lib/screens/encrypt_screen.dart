import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:openpgp/openpgp.dart';
import 'package:flutter/services.dart';
import '/widgets/button_widget.dart';
import '/models/shared_preferences.dart';

class PgpScreen extends StatefulWidget {
  const PgpScreen({Key? key}) : super(key: key);
  static String routeName = '/pgp-page';

  @override
  _PgpScreenState createState() => _PgpScreenState();
}

class _PgpScreenState extends State<PgpScreen> {
  late TextEditingController publicController;
  late TextEditingController textController;
  late TextEditingController encryptedController;
  String encryptionResult = '';

  @override
  void initState() {
    publicController = TextEditingController();
    textController = TextEditingController();
    encryptedController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    publicController.dispose();
    textController.dispose();
    encryptedController.dispose();
    super.dispose();
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
                controller: publicController,
                decoration: InputDecoration(
                  hintText: 'Enter Public key',
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
                          icon: const Icon(Icons.paste),
                          onPressed: () async {
                            publicController.text =
                                await UserSharedPreference.getPublicKey() ?? '';
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 3,
                maxLines: 100,
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter text to encrypt',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textController.clear();
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
                    await OpenPGP.encrypt(
                            textController.text, publicController.text)
                        .then((value) {
                      encryptionResult = value;
                      encryptedController.text = encryptionResult;
                    });
                  },
                  textName: 'ENCRYPT'),
              const SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 3,
                maxLines: 100,
                controller: encryptedController,
                decoration: InputDecoration(
                  hintText: 'Encrypted Text Here',
                  suffixIcon: Column(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            encryptedController.clear();
                          }),
                      const SizedBox(
                        height: 5,
                      ),
                      IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: encryptedController.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Copied Successfully')));
                          }),
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

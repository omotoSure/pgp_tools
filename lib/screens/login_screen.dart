import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:openpgp/openpgp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String routeName = '/login-page';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  void _submitLoginWidget(String email, String username, String password,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'passphrase': password,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('User Not Found!'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('Invalid Password'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('Weak Password'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('Email already in use'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('Invalid Email'),
            backgroundColor: Theme.of(ctx).errorColor,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: LoginWidget(
        submitFn: _submitLoginWidget,
        isLoading: _isLoading,
      ),
    );
  }
}

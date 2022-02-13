import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/screens/tab_screen.dart';
import '/screens/encrypt_screen.dart';
import '/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // OpenPGP.bindingEnabled = false;
  await UserSharedPreference.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PGP',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(secondary: Colors.deepOrange),
          backgroundColor: Colors.green,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.green,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          fontFamily: 'Lato'),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          switch (userSnapshot.connectionState) {
            case ConnectionState.waiting:
              const Center(
                child: CircularProgressIndicator(),
              );
              break;
            // This will check if the email is verified or not
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                if (userSnapshot.hasData) {
                  return const TabScreen();
                }
              } else {
                const VerifyEmailView();
              }
              break;
            default:
            //   return const Text('Loading...');
          }
          if (userSnapshot.hasData) {
            return const TabScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        PgpScreen.routeName: (ctx) => const PgpScreen(),
      },
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Please verify your email address:'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('Sent email verification'))
        ],
      ),
    );
  }
}

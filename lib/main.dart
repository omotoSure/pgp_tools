import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/screens/tab_screen.dart';
import '/screens/encrypt_screen.dart';
import '/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openpgp/openpgp.dart';
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
          if (userSnapshot.hasData) {
            return  const TabScreen();
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

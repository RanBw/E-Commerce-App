import 'package:flutter/material.dart';
import 'package:gaming_gears_app/pages/home.dart';
import 'package:gaming_gears_app/pages/login.dart';
import 'package:gaming_gears_app/pages/verify-email-page.dart';
import 'package:gaming_gears_app/provider/cart.dart';
import 'package:gaming_gears_app/provider/google-signin.dart';
import 'package:gaming_gears_app/shared/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:
              // making a connection between my app and the firebase instance to make sure that this phone already sign in into the app and don't show the login page at the first
              StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return showSnackBar(context, "Something went wrong");
              } else if (snapshot.hasData) {
                return const HomePage();
              } else {
                return const Login();
              }
            },
          )),
    );
  }
}

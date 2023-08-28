// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaming_gears_app/pages/registration.dart';
import 'package:gaming_gears_app/pages/reset-password.dart';
import 'package:gaming_gears_app/provider/google-signin.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:gaming_gears_app/shared/constants.dart';
import 'package:gaming_gears_app/shared/snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

//import 'package:gaming_gears/shared/custom_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // ignore: use_build_context_synchronously
      showSnackBar(context, "done");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password provided for that user.");
      } else {
        showSnackBar(context, "Error occur");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  // نضيف هذه الميثود عشان البرفورمانس حق التطبيق يعني انه نتخلص من ال controller
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // the provider for google sign in so we can use the login method
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(
            "Login",
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 44, vertical: 0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // since we are gonna duplicate the TextField widget so we r gonna use the Reusable Widgets concept -> we have two ways to do it
                  // one with creating a custom widget in shared folder
                  //two creating a constant of one of the widget which is in this case the "InputDecoration" widget :)
                  // I prefer the second option so im gonna use it but I will comment the first option under this so u can see how

                  //for the first textfield
                  /*  
                
                  CustomTextField(
                      typeOfInput: TextInputType.emailAddress,
                      isPassword: false,
                      hintText: "Enter your Email: ",
                      icon: Icon(Icons.email)),
                
                */

                  // now we are gonna use the const way-method

                  TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,

                      // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                      decoration: customInputDecoration.copyWith(
                          hintText: "Enter your Email: ",
                          suffixIcon: Icon(Icons.email))),

                  SizedBox(
                    height: 22,
                  ),

                  //for the second textfield
                  /*  
                
                
                  CustomTextField(
                      typeOfInput: TextInputType.text,
                      isPassword: true,
                      hintText: "Enter your Password: ",
                      icon: Icon(Icons.lock)),
                
                */

                  TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: isVisible,

                      // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                      decoration: customInputDecoration.copyWith(
                          hintText: "Enter your Password: ",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: isVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ))),
                  SizedBox(
                    height: 33,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11))),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                  ),
                  SizedBox(
                    height: 9,
                  ),

                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()));
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(decoration: TextDecoration.underline),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Do not have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                          },
                          child: Text("Sign Up"))
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    width: 299,
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          ///thickness: 0.6,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )),
                        Text(
                          "OR",
                        ),
                        Expanded(
                            child: Divider(
                          // thickness: 0.6,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      googleSignInProvider.googlelogin();
                    },
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: mainColor, width: 0.2),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/google.svg",
                        height: 33,
                        fit: BoxFit.cover,
                        //color: mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

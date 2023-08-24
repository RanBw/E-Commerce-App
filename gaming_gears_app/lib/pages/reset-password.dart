import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaming_gears_app/pages/login.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:gaming_gears_app/shared/constants.dart';
import 'package:gaming_gears_app/shared/snackbar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();
  bool isLoading = false;

  resetPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      showSnackBar(context, "Done - please check your email");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, " Error: ${e.code}");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email to reset your password.",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
              child: TextFormField(
                validator: (value) {
                  return value != null && !EmailValidator.validate(value)
                      ? "please enter a valid email"
                      : null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                keyboardType: TextInputType.text,
                decoration: customInputDecoration.copyWith(
                    hintText: "Email: ", suffixIcon: const Icon(Icons.email)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  resetPassword();
                } else {
                  showSnackBar(context, "Something wrong..");
                }
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11))),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Reset Password"),
            )
          ],
        ),
      ),
    );
  }
}

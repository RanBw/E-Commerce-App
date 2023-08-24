import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType typeOfInput;
  final bool isPassword;
  final String hintText;
  final Icon icon;
  // ignore: prefer_typing_uninitialized_variables
  final myController;
  const CustomTextField(
      {super.key,
      required this.typeOfInput,
      required this.isPassword,
      required this.hintText,
      required this.icon,
      required this.myController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
      child: TextFormField(
        //  validator: (value) {},
        controller: myController,
        keyboardType: typeOfInput,
        obscureText: isPassword,
        decoration: InputDecoration(
            // to delete the under border
            enabledBorder: OutlineInputBorder(
                borderSide: Divider.createBorderSide(context)),
            prefixIcon: icon,
            iconColor: const Color.fromARGB(255, 1, 49, 89),
            // to change the focused color  by default it's grey
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 1, 49, 89))),
            // fillColor: Color.fromARGB(255, 145, 145, 145),
            filled: true,
            hintText: hintText,
            contentPadding: const EdgeInsets.all(10)),
      ),
    );
  }
}

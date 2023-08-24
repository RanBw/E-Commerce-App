import 'package:flutter/material.dart';

// in constant way - method we simply creating any widget or any variable here in type of const so we can use it any where in our project

// our InputDecoration is under >>
const customInputDecoration = InputDecoration(
    // to delete the under border
    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
    //   prefixIcon: icon,
    iconColor: Color.fromARGB(255, 1, 49, 89),
    // to change the focused color  by default it's grey
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 1, 49, 89))),
    // fillColor: Color.fromARGB(255, 145, 145, 145),
    filled: true,
    //  hintText: hintText,
    contentPadding: EdgeInsets.all(10));

import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    action: SnackBarAction(label: "close", onPressed: () {}),
    duration: const Duration(days: 1),
  ));
}

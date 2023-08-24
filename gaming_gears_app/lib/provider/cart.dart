import 'package:flutter/material.dart';
import 'package:gaming_gears_app/models/items-class.dart';

class Cart with ChangeNotifier {
  List cart = [];

  double sum = 0;

  add(GridItems product) {
    cart.add(product);
    sum += product.price.round();
    notifyListeners();
  }

  remove(GridItems product) {
    cart.remove(product);

    sum -= product.price;

    notifyListeners();
  }

  get itemCount {
    return cart.length;
  }
}

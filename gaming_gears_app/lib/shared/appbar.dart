import 'package:flutter/material.dart';
import 'package:gaming_gears_app/pages/checkout.dart';
import 'package:gaming_gears_app/provider/cart.dart';
import 'package:provider/provider.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: ((context, cartInstancee, child) {
      return Row(
        children: [
          Stack(children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.blue[200], shape: BoxShape.circle),
              child: Text("${cartInstancee.cart.length}"),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckOut()),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart))
          ]),
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text("${cartInstancee.sum}SR",
                  style: const TextStyle(fontSize: 18))),
        ],
      );
    }));
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gaming_gears_app/provider/cart.dart';
import 'package:gaming_gears_app/shared/appbar.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    //another way of using the provider but in this way we are making the instance for the whole build function so when we r add or removing or any update on the provider class it's going to reload the whole page from the build function instead of reload the specific widget like consumer method
    final cartInstance = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        actions: const [
          AppBarAction(),
        ],
        backgroundColor: mainColor,
        title: Text(
          "Check Out",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 600,
              child: ListView.builder(
                  itemCount: cartInstance.cart.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(cartInstance.cart[index].name),
                        subtitle:
                            Text(cartInstance.cart[index].price.toString()),
                        leading: CircleAvatar(
                          child: Image.asset(
                            cartInstance.cart[index].path,
                            fit: BoxFit.cover,
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              cartInstance.remove(cartInstance.cart[index]);
                            },
                            icon: Icon(Icons.remove)),
                      ),
                    );
                  }),
            ),
            cartInstance.sum <= 0
                ? Text("")
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: acceptColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 16)),
                    onPressed: () {},
                    child: Text(
                      "Pay ${cartInstance.sum.toString()}",
                      style: TextStyle(fontSize: 18),
                    )),
            SizedBox(
              height: 22,
            )
          ],
        ),
      ),
    );
  }
}

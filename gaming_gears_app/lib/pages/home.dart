// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaming_gears_app/models/getting-data-for-drawer.dart';
import 'package:gaming_gears_app/models/items-class.dart';

import 'package:gaming_gears_app/pages/checkout.dart';
import 'package:gaming_gears_app/pages/details-page.dart';
import 'package:gaming_gears_app/pages/profile-page.dart';
import 'package:gaming_gears_app/provider/cart.dart';
import 'package:gaming_gears_app/shared/appbar.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final credential = FirebaseAuth.instance.currentUser;
  bool googleSignInORN = false;

  checkGoogleSignIn() async {
    var methods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(credential!.email.toString());
    if (methods.contains('google.com')) {
      setState(() {
        googleSignInORN = true;
      });
    }
  }

  @override
  void initState() {
    checkGoogleSignIn();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // creating an instance for the user from the firebase so we can take his google picture
    // final user = FirebaseAuth.instance.currentUser!;
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                googleSignInORN
                    ? UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://plainbackground.com/plain1024/26a7de.png"),
                              fit: BoxFit.cover),
                        ),
                        // getting my username from my gmail account to the app
                        accountName: Text(credential!.displayName.toString()),
                        // getting my email from my gmail account to the app
                        accountEmail: Text(credential!.email.toString()),
                        currentAccountPicture: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(66, 123, 121, 121),
                            radius: 64,
                            backgroundImage:
                                NetworkImage(credential!.photoURL.toString())))
                    :
                    //  فصلنا المعلومات المكتوبه على الدراور بحيث نقدر ناخذها من الفايبر بيس من خلال ملف اسمه GettingDrawerData

                    GettingDrawerData(),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  title: Text("Home"),
                  leading: Icon(Icons.home),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckOut()));
                  },
                  title: Text("My Products"),
                  leading: Icon(Icons.shopping_bag),
                ),
                ListTile(
                  onTap: () {},
                  title: Text("About"),
                  leading: Icon(Icons.help_center),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                  },
                  title: Text("Profile Page"),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  title: Text("Logout"),
                  leading: Icon(Icons.logout),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Text(
                  "2023 \u00a9 Developed by Rana Eid ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          AppBarAction(),
        ],
        backgroundColor: mainColor,
        title: Text(
          "Home",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //عدد العناصر بكل صف
              crossAxisCount: 2,
              // العنصر نفسه كم طوله وعرضه هنا طوله 2 وعرضه 3
              childAspectRatio: 3 / 2,
              // المسافه بين كل عنصر وعنصر على محور الاكس
              crossAxisSpacing: 10,
              // المسافه بين كل عنصر وعنصر على محور الواي
              mainAxisSpacing: 33),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      index: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 11),
                child: GridTile(
                  child: Image.asset(items[index].path, fit: BoxFit.cover),
                  key: ValueKey("value"),
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      items[index].name,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${items[index].price}SR"),

                    // using the provider by using consumer
                    trailing: Consumer<Cart>(
                        builder: ((context, classInstancee, child) {
                      return IconButton(
                        onPressed: () {
                          classInstancee.add(items[index]);
                        },
                        icon: Icon(Icons.shopping_cart),
                      );
                    })),
                  ),
                ),
              ),
            );
          }),
    ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaming_gears_app/shared/colors.dart';

class GettingDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GettingDataFromFirestore({super.key, required this.documentId});

  @override
  State<GettingDataFromFirestore> createState() =>
      _GettingDataFromFirestoreState();
}

class _GettingDataFromFirestoreState extends State<GettingDataFromFirestore> {
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final majorController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final credential = FirebaseAuth.instance.currentUser;
  editProfileData() {
    if (usernameController.text != "") {
      users.doc(credential!.uid).update({"username": usernameController.text});
    } else {}
    if (majorController.text != "") {
      users.doc(credential!.uid).update({"major": majorController.text});
    } else {}
    if (ageController.text != "") {
      users.doc(credential!.uid).update({"age": ageController.text});
    } else {}

    usernameController.clear();
    majorController.clear();
    ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(37, 96, 125, 139),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 22),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Username: ${data['username']} ",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Major: ${data['major']} ",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Age: ${data['age']} ",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11)),
                                child: Container(
                                  height: 310,
                                  padding: const EdgeInsets.all(22),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0,
                                                )),
                                            labelText: "Username",
                                            hintText: "${data['username']}"),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      TextField(
                                        controller: majorController,
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0,
                                                )),
                                            labelText: "Major",
                                            hintText: "${data['major']}"),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      TextField(
                                        controller: ageController,
                                        decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0,
                                                )),
                                            labelText: "Age",
                                            hintText: "${data['age']}"),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                editProfileData();

                                                setState(() {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text(
                                                "Update",
                                                style: TextStyle(fontSize: 18),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Close",
                                                  style:
                                                      TextStyle(fontSize: 18)))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(mainColor)),
                      child: const Text(
                        "Edit",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}

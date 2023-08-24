import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GettingUserImg extends StatefulWidget {
  const GettingUserImg({super.key});

  @override
  State<GettingUserImg> createState() => _GettingUserImgState();
}

class _GettingUserImgState extends State<GettingUserImg> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final credential = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
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
          return CircleAvatar(
              backgroundColor: const Color.fromARGB(66, 123, 121, 121),
              radius: 64,
              backgroundImage: NetworkImage(data["imgURL"]));
        }

        return const Text("loading");
      },
    );
  }
}

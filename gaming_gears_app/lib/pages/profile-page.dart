import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gaming_gears_app/models/getting-data-from-firestore.dart';
import 'package:gaming_gears_app/models/user-img.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final credential = FirebaseAuth.instance.currentUser;
  File? imgPath;
  //Global Variable so we can use it everywhere
  String? imgName;
  String? url;
  uploadImg(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);

    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";

          updateImg();
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  updateImg() async {
    if (imgPath != null) {
      final storageRef = FirebaseStorage.instance.ref("users-imgs/$imgName");
      await storageRef.putFile(imgPath!);

      // getting url and store it in the document so we can use it in pages
      url = await storageRef.getDownloadURL();

      users.doc(credential!.uid).update({"imgURL": url});
    }
  }

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
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                googleSignInORN
                    ? CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(66, 123, 121, 121),
                        radius: 64,
                        backgroundImage: NetworkImage(user.photoURL.toString()))
                    : Stack(
                        children: [
                          (imgPath == null)
                              ? const GettingUserImg()
                              : ClipOval(
                                  child: Image.file(
                                  imgPath!,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                )),
                          Positioned(
                            bottom: -10,
                            right: -5,
                            child: IconButton(
                                color: const Color.fromARGB(255, 94, 115, 128),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 120,
                                          //  color: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 22),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    uploadImg(
                                                        ImageSource.camera);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.camera),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "From Camera",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    uploadImg(
                                                        ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons.photo),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "From Gallary",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.add_a_photo)),
                          )
                        ],
                      ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(37, 96, 125, 139),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Email:  ${user.email}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Joined:  ${DateFormat.yMMMd().format(user.metadata.creationTime!)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GettingDataFromFirestore(documentId: user.uid),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  user.delete();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(11),
                    backgroundColor: Colors.red),
                child: const Text(
                  "Delete account",
                  style: TextStyle(fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}

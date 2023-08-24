import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gaming_gears_app/pages/login.dart';
import 'package:gaming_gears_app/shared/colors.dart';
import 'package:gaming_gears_app/shared/constants.dart';
import 'package:gaming_gears_app/shared/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controllers

  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final majorController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible = true;

  final _formKey = GlobalKey<FormState>();

  // لمسة اضافية
  bool isLoading = false;

  //password checking rules
  bool has8Characters = false;
  bool atLeast1Number = false;
  bool hasUppercase = false;
  bool hasLowerCase = false;
  bool hasSpecialCharacters = false;
  //creating a method to check for all of these and we can use it by "onChanged" propriety that in textFormField passing the value to this method :))

  checkingPasswordValidation(String password) {
    setState(() {
      has8Characters = false;
      atLeast1Number = false;
      hasUppercase = false;
      hasLowerCase = false;
      hasSpecialCharacters = false;

      if (password.contains(RegExp(r'.{8,}'))) {
        has8Characters = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        atLeast1Number = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowerCase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  register() async {
    // نجعل هذه القيمة ب true بدايه الميثود  لكي نجعل المستخدم يرى دائرة التحميل

    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (imgPath != null && imgName != null) {
        final storageRef = FirebaseStorage.instance.ref("users-imgs/$imgName");
        await storageRef.putFile(imgPath!);

        // getting url and store it in the document so we can use it in pages
        url = await storageRef.getDownloadURL();
      } else {
        url =
            "https://twirpz.files.wordpress.com/2015/06/twitter-avi-gender-balanced-figure.png";
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

//by using credential variable we can get the user and his ID "uid" >> by using uid we can make a special doc in the collection based on user's id
      users
          // we have to put ! after user
          .doc(credential.user!.uid)
          .set({
            'username': usernameController.text,
            'age': ageController.text,
            'major': majorController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'imgURL': url
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     duration: Duration(days: 1),
        //     action: SnackBarAction(label: "close", onPressed: () {}),
        //     content: Text("The password provided is too weak.")));

        //!!!since where going to use the snackBar more than once we made a file called snackbar.dart in the shared folder for his function we can use it everywhere in the project

        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const RegisterPage()));
        showSnackBar(context, 'The account already exists for that email.');
      } else {
        showSnackBar(context, 'Error - Try again later.');
      }
    } catch (e) {
      print(e);
    }
    // ثم نرجعها الى القيمة الافتراضيه false بحيث يرى المستخدم كلمة sign up
    setState(() {
      isLoading = false;
    });
  }

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
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  // نضيف هذه الميثود عشان البرفورمانس حق التطبيق يعني انه نتخلص من ال controller
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    ageController.dispose();
    majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 22,
                  ),

                  Stack(
                    children: [
                      (imgPath == null)
                          ? const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(66, 123, 121, 121),
                              radius: 64,
                              backgroundImage:
                                  AssetImage("assets/icons/profilepic.png"))
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
                                                uploadImg(ImageSource.camera);
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
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                uploadImg(ImageSource.gallery);
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
                                                    style:
                                                        TextStyle(fontSize: 18),
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
                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        // obscureText: isPassword,

                        // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                        decoration: customInputDecoration.copyWith(
                            hintText: "Enter your username: ",
                            suffixIcon: const Icon(Icons.person))),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        // obscureText: isPassword,

                        // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                        decoration: customInputDecoration.copyWith(
                            hintText: "Enter your age: ",
                            suffixIcon: const Icon(Icons.numbers))),
                  ),

                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: TextFormField(
                        controller: majorController,
                        keyboardType: TextInputType.text,
                        // obscureText: isPassword,

                        // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                        decoration: customInputDecoration.copyWith(
                            hintText: "Enter your major: ",
                            suffixIcon: const Icon(Icons.subject))),
                  ),

                  // CustomTextField(
                  //     myController: usernameController,
                  //     typeOfInput: TextInputType.name,
                  //     isPassword: false,
                  //     hintText: "Enter your Username: ",
                  //     icon: Icon(Icons.person)),
                  const SizedBox(
                    height: 22,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: TextFormField(
                        validator: (value) {
                          return value != null &&
                                  !EmailValidator.validate(value)
                              ? "please enter a valid email"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        // obscureText: isPassword,

                        // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                        decoration: customInputDecoration.copyWith(
                            hintText: "Enter your email: ",
                            suffixIcon: const Icon(Icons.email))),
                  ),

                  // CustomTextField(
                  //     myController: emailController,
                  //     typeOfInput: TextInputType.emailAddress,
                  //     isPassword: false,
                  //     hintText: "Enter your Email: ",
                  //     icon: Icon(Icons.email)),
                  const SizedBox(
                    height: 22,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: TextFormField(

                        //through this property we can pass the password value to our beautiful method
                        onChanged: (value) {
                          checkingPasswordValidation(value);
                        },
                        validator: (value) {
                          return value!.length < 8
                              ? "please enter a valid password"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: isVisible,
                        // obscureText: isPassword,

                        // we here using the const variable that we created but since each textfield has it own "hintText" and own "prefixIcon" so we r using the variable."copyWith()" to add more properties
                        decoration: customInputDecoration.copyWith(
                            hintText: "Enter your password: ",
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                child: isVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  has8Characters ? Colors.green : Colors.white,
                              border: Border.all(color: Colors.grey.shade400)),
                          child: const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text("Has at least 8 characters")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  atLeast1Number ? Colors.green : Colors.white,
                              border: Border.all(color: Colors.grey.shade400)),
                          child: const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text("At least 1 number")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasUppercase ? Colors.green : Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text("Has uppercase")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasLowerCase ? Colors.green : Colors.white,
                              border: Border.all(color: Colors.grey.shade400)),
                          child: const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text("Has lowercase")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 44, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasSpecialCharacters
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey.shade400)),
                          child: const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text("Has special characters")
                      ],
                    ),
                  ),

                  // CustomTextField(
                  //     myController: passwordController,
                  //     typeOfInput: TextInputType.text,
                  //     isPassword: true,
                  //     hintText: "Enter your Password: ",
                  //     icon: Icon(Icons.lock)),

                  //for the second textfield

                  const SizedBox(
                    height: 33,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await register();
                        if (!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      } else {
                        showSnackBar(context,
                            "somthing wrong - check your email-password validate");
                      }
                    },

                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 12),
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11))),

                    //هنا نستخدم ال isLoading متغير
                    //بحيث نقوم بالمقارنة بقيمته اذا كانت صح او خطأ ومن خلال القيمة نظهر ال child المناسب
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("you have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text("Sign in"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

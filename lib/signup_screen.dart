import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Components/appbar.dart';
import 'package:flutter_firebase/Components/button.dart';
import 'package:flutter_firebase/Components/textfield.dart';
import 'package:flutter_firebase/constants/constants.dart';
import 'package:flutter_firebase/login_screen.dart';
import 'package:flutter_firebase/ok_screen.dart';
import 'package:flutter_firebase/utilis/toasts.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final userPasswordController = TextEditingController();
  final userEmailController = TextEditingController();
  final userNameController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    userEmailController.dispose();
    userNameController.dispose();
    userPasswordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
        email: userEmailController.text.toString(),
        password: userPasswordController.text.toString())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user?.uid)
          .set({
        'username': userNameController.text,
        'useremail':  userEmailController.text,
        'userpassword':  userPasswordController.text,
      });
      setState(() {
        loading = false;
      });
      Get.to(() => okScreen());
    }).onError((error, stackTrace) {
      Toasts().toastsMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      loading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Get.to(() => okScreen());
        }
      }
    } catch (error) {
      Toasts().toastsMessage('Google Sign-In Failed: ${error.toString()}');
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: AppText.signUpAppbarText),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 150,
                width: screenWidth,
                child: Lottie.asset(AppImages.loginPageImage),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTextFormField(
                    controller: userNameController,
                    hintText: 'User Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    suffixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTextFormField(
                    controller: userEmailController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTextFormField(
                    controller: userPasswordController,
                    hintText: 'Password',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    suffixIcon: Icon(Icons.lock_open),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: RoundButton(
                  onTap: () async {
                    login();
                  },
                  loading: loading,
                  title: 'Sign In',
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: RoundButton(
                  onTap: () async {
                    signInWithGoogle();
                  },
                  loading: loading,
                  title: 'SignIn with Google Account',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Already have an account SignIn'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 var userName = userNameController.text.trim();
                  var userPassword = userPasswordController.text.trim();
                  var userEmail = useEmailController.text.trim();

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: userEmail,
                        password: userPassword,
                      )
                      .then((value) => {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc()
                                .set({
                              'username': userName,
                              'useremail': userEmail,
                              'userpassword': userPassword,
                            })
                          });
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Components/appbar.dart';
import 'package:flutter_firebase/Components/button.dart';
import 'package:flutter_firebase/Components/textfield.dart';
import 'package:flutter_firebase/constants/constants.dart';
import 'package:flutter_firebase/login_screen.dart';
import 'package:flutter_firebase/home_screen.dart';
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
      Get.to(() => HomeScreen());
    }).onError((error, stackTrace) {
      Toasts().toastsMessage(error.toString(),false, success: false);
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
          Get.to(() => HomeScreen());
        }
      }
    } catch (error) {
      Toasts().toastsMessage('Google Sign-In Failed: ${error.toString()}',false, success: false);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: const CustomAppBar(title: AppText.signUpAppbarText),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
             SizedBox(height:150,),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30 ),
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
                    prefixIcon: Icon(Icons.person, color: AppColors.colorGreen,),
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
                    prefixIcon: Icon(Icons.email, color: AppColors.colorGreen,),
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
                    prefixIcon: Icon(Icons.lock_open, color: AppColors.colorGreen,),
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
                  child: Text('Already have an account? SignIn'),
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

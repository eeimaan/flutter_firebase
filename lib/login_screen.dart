import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Components/button.dart';
import 'package:flutter_firebase/Components/textfield.dart';
import 'package:flutter_firebase/forget_password_screen.dart';
import 'package:flutter_firebase/ok_screen.dart';
import 'package:flutter_firebase/signup_screen.dart';
import 'package:flutter_firebase/utilis/toasts.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'Components/appbar.dart';
import 'constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginok() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
        Get.to(() => okScreen());
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Toasts().toastsMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: AppText.loginAppbarText),
      body: SingleChildScrollView(
        
        child: Container(
          child: Column(children: [
                     SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.to(() => okScreen());
              },
                child: Align(
                   alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 50,height: 20,
                      decoration: BoxDecoration(
                            color: AppColors.colorGreen,
                            borderRadius: BorderRadius.circular(5)
                          ),
                                child: Center(
                                  child: Text(
                                    'skip',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                  ),
                )),
            Container(
              alignment: Alignment.center,
              height: 300,
              width: screenWidth,
              child: Lottie.asset(AppImages.loginPageImage),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextFormField(
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Email';
                    }
                    return null;
                  },
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextFormField(
                  hintText: 'Password',
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
            ),
          
            GestureDetector(
              onTap: () {
                Get.to(() => ForgetPasswordScreen());
              },
              child: Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Forget Password?'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: RoundButton(
                  onTap: () async {
                    loginok();
                  },
                  loading: loading,
                  title: 'Login'),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => SignUpScreen());
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Dont have an account SignUp?'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

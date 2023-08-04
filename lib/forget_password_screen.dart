import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Components/button.dart';
import 'package:flutter_firebase/utilis/toasts.dart';

import 'Components/appbar.dart';
import 'Components/textfield.dart';
import 'constants/constants.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
   final userEmailController = TextEditingController();
     final _auth = FirebaseAuth.instance ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const CustomAppBar(title: AppText.forgetPasswordAppbarText),
      body: Container(
          child: Column(
        children: [
          SizedBox(height: 10),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTextFormField(
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                
                  return null;
                },
                suffixIcon: Icon(Icons.email),
              ),
            ),
          ),
          SizedBox(height: 10),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
             child: RoundButton(title: 'Forgot', onTap: (){
                _auth.sendPasswordResetEmail(email: userEmailController.text.toString()).then((value){
                  Toasts().toastsMessage('We have sent you email to recover password, please check email');
                }).onError((error, stackTrace){
                Toasts().toastsMessage(error.toString());
                });
              }),
           )
        ],
      )),
    );
  }
}

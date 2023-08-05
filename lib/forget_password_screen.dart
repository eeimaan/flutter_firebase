import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Components/button.dart';
import 'Components/appbar.dart';
import 'Components/textfield.dart';
import 'constants/constants.dart';
import 'utilis/toasts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final userEmailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  void _resetPassword() async {
    if (userEmailController.text.isEmpty) {
      Toasts().toastsMessage('Please enter your email.');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: userEmailController.text);
      Toasts().toastsMessage(
          'Password reset email sent to ${userEmailController.text}.');
    } catch (error) {
      Toasts().toastsMessage(
          'Failed to send password reset email. Please try again.');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

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
                  controller: userEmailController,
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
              child: RoundButton(
                title: 'Forgot',
                loading: loading,
                onTap: ()async {
                   if (userEmailController.text.isEmpty) {
      Toasts().toastsMessage('Please enter your email.');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: userEmailController.text);
      Toasts().toastsMessage(
          'Password reset email sent to ${userEmailController.text}.');
    } catch (error) {
      Toasts().toastsMessage(
          'Failed to send password reset email. Please try again.');
    } finally {
      setState(() {
        loading = false;
      });
    }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

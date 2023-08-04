import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/utilis/toasts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';

class okScreen extends StatefulWidget {
  const okScreen({Key? key}) : super(key: key);

  @override
  State<okScreen> createState() => okScreenState();
}

class okScreenState extends State<okScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Text('Successfully '),
              ),
            ),
            if (_image != null) Image.file(_image!),
            ElevatedButton(
              onPressed: () async {
                await uploadImage();
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User not authenticated.');
      return;
    }

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    final imageName = path.basename(imageFile.path);
    final reference = _storage.ref().child('images/$imageName');

    try {
      await reference.putFile(imageFile);
      final downloadURL = await reference.getDownloadURL();

      await _firestore.collection('users').doc(user.uid).set({
        'imageURL': downloadURL,
      });

      setState(() {
        _image = imageFile;
      });

     
      Toasts().toastsMessage('Image uploaded successfully!');
    } catch (error) {
     
      Toasts().toastsMessage('Failed to upload image. Please try again.');
    }
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/Components/button.dart';
import 'package:flutter_firebase/utilis/toasts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  bool loading = false;

  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Toasts().toastsMessage('No Image  picked !');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload screen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Text('Successfully created account'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(child: Icon(Icons.image)),
                  ),
                ),
              ),
              //if (_image != null) Image.file(_image!),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: RoundButton(
                  onTap: () async {
                    //await uploadImage();
                    firebase_storage.Reference ref = firebase_storage
                        .FirebaseStorage.instance
                        .ref('/foldername' +
                            DateTime.now().millisecondsSinceEpoch.toString());

                    firebase_storage.UploadTask uploadTask =
                        ref.putFile(_image!.absolute);

                    Future.value(uploadTask).then((value) async {
                      var newUrl = await ref.getDownloadURL();
                      databaseRef
                          .child('1')
                          .set({'id': '1212', 'title': newUrl.toString()}).then(
                              (value) {
                        setState(() {
                          loading = false;
                        });
                        Toasts().toastsMessage('uploaded');
                      }).onError((error, stackTrace) {
                        print(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    }).onError((error, stackTrace) {
                      Toasts().toastsMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                  title: 'Upload Image',
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
  Future<void> uploadImage() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User not authenticated.');
      return;
    }

    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
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
*/
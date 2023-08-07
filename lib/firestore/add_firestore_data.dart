import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/Components/appbar.dart';
import 'package:flutter_firebase/Components/button.dart';
import 'package:flutter_firebase/utilis/toasts.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  // final databaseRef = FirebaseDatabase.instance.ref('Post');
  final fireStore = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add  firestore Post',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
              child: RoundButton(
                  title: 'Add',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
            
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    fireStore.doc(id).set({
                      'title': postController.text.toString(),
                      'id': DateTime.now().millisecondsSinceEpoch.toString()
                    }).then((value) {
                      Toasts().toastsMessage('Post added');
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Toasts().toastsMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

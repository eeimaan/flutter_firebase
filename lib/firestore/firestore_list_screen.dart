import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/constants/constants.dart';
import 'package:flutter_firebase/firestore/add_firestore_data.dart';
import 'package:flutter_firebase/login_screen.dart';
import 'package:flutter_firebase/utilis/toasts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post list', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.colorGreen,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Toasts().toastsMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: posts.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['id'].toString()),
                      subtitle: Text(data['title']),
                      onTap: () {
                        _showPopupMenu(context, document.id); // Passing document ID
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        backgroundColor: AppColors.colorGreen,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, String documentId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: AppColors.colorGreen,
                ),
                title: Text(
                  'Update',
                  style: TextStyle(color: AppColors.colorGreen),
                ),
                onTap: () {
                  _updatePost(documentId); // Passing document ID
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  _deletePost(documentId); // Passing document ID
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deletePost(String documentId) async {
    try {
      await posts.doc(documentId).delete();
      print("Post deleted");
      Toasts().toastsMessage("Post deleted");
    } catch (error) {
      print("Failed to delete post: $error");
      Toasts().toastsMessage("Failed to delete post: $error");
    }
  }
Future<void> _updatePost(String documentId) async {
  TextEditingController _textFieldController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Update Post", style: TextStyle(
                    color:AppColors.colorGreen, fontSize: 16, fontWeight: FontWeight.bold,
                  ),),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "Enter new title"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Update"),
            onPressed: () async {
              String newTitle = _textFieldController.text;
              Navigator.pop(context); // Close the dialog

              try {
                await posts.doc(documentId).update({'title': newTitle});
                print("Post updated");
                Toasts().toastsMessage("Post updated");
              } catch (error) {
                print("Failed to update post: $error");
                Toasts().toastsMessage("Failed to update post: $error");
              }
            },
          ),
          TextButton(
            child: Text("Cancel", style: TextStyle(
                    color: Colors.red,
                  ),),
            onPressed: () {
              Navigator.pop(context); 
            },
          ),
        ],
      );
    },
  );
}

}

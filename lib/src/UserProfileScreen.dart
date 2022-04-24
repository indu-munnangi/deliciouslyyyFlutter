
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserProfilePage extends StatefulWidget {
  var user_detail;
  UserProfilePage({
    Key? key,
    required this.user_detail,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
    List<firebase_storage.UploadTask> _uploadTasks = [];
  var localUserDetails;
  final picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? user;

  var _ratingValue = 0.0;
// var user_details;

Future getUserDetailsById() async{
  if(widget.user_detail['user_id'] != null){
  await firestore
  .collection('users')
  .where('user_id',isEqualTo: widget.user_detail['user_id'])
  .get()
  .then((value)  {
    var data = value.docs[0].data();
    setState(() {
      localUserDetails = data;
    });
  });
  }
}

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
    setState(() {
      localUserDetails = widget.user_detail;
    });
    getUserRating();
    // getUserDetailsById();
  }

Future<firebase_storage.UploadTask?> uploadFile(XFile? file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));

      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('/${widget.user_detail['user_id']}.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    
    // print(file.path);
    // print(metadata);
    try{

    uploadTask = ref.putFile(io.File(file.path), metadata);
    return Future.value(uploadTask);
    }catch(e){
      // print(e);
    }
    
    // uploadTask = ref.putData(await file.readAsBytes(), metadata);
    

  }
Future<void> _downloadLink(firebase_storage.Reference ref) async {
    final link = await ref.getDownloadURL();
   
    CollectionReference _users = firestore.collection('users');
    await _users.doc(widget.user_detail['user_id']).set(
      {
        'imageUrl': link
      },new SetOptions(merge: true)).then((x){
        Future.delayed(const Duration(milliseconds: 1000), () {
          getUserDetailsById();
  // setState(() {
  //   // Here you can write your code for open new view
  // });
});
      
      });
  }

Future<void> handleUploadType() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    firebase_storage.UploadTask? task = await uploadFile(file);
     if (task != null) {
       _uploadTasks = [..._uploadTasks, task];
            await _downloadLink(_uploadTasks[0].snapshot.ref);
          setState(()  {
             _uploadTasks = [..._uploadTasks, task];
            // await _downloadLink(_uploadTasks[0].snapshot.ref);
          });
        }
    }
  
  // Future selectOrTakePhoto(ImageSource imageSource) async {
  //   // final picker = ImagePicker();
  //   setState(() {
  //     //inProcess=true;
  //   });
  //           final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //       firebase_storage.UploadTask? task = await uploadFile(file);

  //   // final imageFile = await picker.getImage(source: imageSource);
  //   if (imageFile != null) {
  //     print('image is not null'); 
  //     setState(() {
  //     _image = File(imageFile.path);
  //     // convertToBase64(_image);
  //     //inProcess=false;
  //     uploadToFirebase(_image);
  //   });
  //   }
  // }

  // void convertToBase64(File? image) {

  //   final bytes = File(image!.path).readAsBytesSync();
  //   String base64Image =  "data:image/png;base64,"+base64Encode(bytes);
  //   print(base64Image);

  //   CollectionReference _users = firestore.collection('users');
  //       _users.doc(user!.uid).set(
  //         {
  //                 'imageUrl': base64Image
  //                 },new SetOptions(merge: true));
  // }



  // Future<String> uploadFile(image) async {
  //   print('upload file');
  //   String downloadURL;
  //   String postId = DateTime.now().millisecondsSinceEpoch.toString();
    
  //   FirebaseStorage.ref(image).putFile(
  //           imageFile);
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("images")
  //       .child("post_$postId.jpg");
  //   await ref.putFile(image);
  //   downloadURL = await ref.getDownloadURL();
  //   print(downloadURL);
  //   return downloadURL;
  // }

  // Future uploadToFirebase(_image) async {
  //   print('upload to firebase');
  //   String url = await uploadFile(_image!);
  //   print(url);
  //   user?.updatePhotoURL(url);

  //   firestore
  //       .collection('users')
  //       .where('user_id', isEqualTo: user?.uid)
  //       .get()
  //       .then((QuerySnapshot) {});
  // }

    Future getUserRating() async{
      // print(widget.user_detail['user_id']);
        await firestore
        .collection('ratings')
        .where('receiver_id', isEqualTo: widget.user_detail['user_id'])
        .get()
        .then((querySnapshot){
            var docs = querySnapshot.docs;
            var sum = 0.0;
            // print(docs.length);
            if(docs.isNotEmpty){
              docs.forEach((e) => sum = sum + e.get('rating'),);
            }
            setState(() {
              _ratingValue = docs.isNotEmpty ? sum/docs.length : 0;
            });
        });
    }


  Future _showSelectionDialog() async {
    await showDialog(
      builder: (context) => SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              // print('on pressed gallery');
              // selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          // SimpleDialogOption(
          //   child: Text('Take a photo'),
          //   onPressed: () {
          //     selectOrTakePhoto(ImageSource.camera);
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      child: GestureDetector(
                        onTap: () {
                          user!.uid == widget.user_detail['user_id'] ? handleUploadType():'';
                        },
                        // },
                        // child: _image == null
                        //     ? Image.asset(
                        //         'assets/me.png') // set a placeholder image when no photo is set
                        //     : Image.file(_image!),

                        child: CircleAvatar(
                          backgroundImage: NetworkImage(localUserDetails['imageUrl'] == null ? 'https://firebasestorage.googleapis.com/v0/b/fan-page-firebase-67c6a.appspot.com/o/playground%2Fpngwing.com.png?alt=media&token=0bbac1c6-cf11-4c90-9cfe-713c5faf79ce' : localUserDetails['imageUrl'] ),
                          minRadius: 80.0,
                          // child: Text(
                          //   'Add image'
                          // ),

                        ),
                      ),
                    ),
                  ]),
              SizedBox(
                height: 50,
              ),
              ListTile(
                trailing: const Icon(Icons.person),
                title: Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.user_detail['name'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                trailing: const Icon(Icons.email),
                title: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.user_detail['email'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Divider(),
             
            ]),
      ),
    );
  }


  

}



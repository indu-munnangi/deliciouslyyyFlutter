import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home_Screen.dart';
import 'start_screen.dart';
import 'widgets.dart';

class Signup extends StatefulWidget {
  const Signup({ Key? key }) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name, _email, _password;

  Future<void> checkAuthentication() async {

    _auth.authStateChanges().listen((user) async {
      if (user != null) {
          Navigator.push<void>(context, MaterialPageRoute(builder: (context)=> const Home()));
          dispose();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  void addUserData(User user){
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference _users = firestore.collection('users');
        _users.doc(user.uid).set(
          {
                  'name' : _name,
                  'user_id' : user.uid,
                  'user_role': 'customer',
                  'email':user.email,
                  'tis': DateTime.now().millisecondsSinceEpoch,
                  'imageUrl': 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Davatar&psig=AOvVaw36Ph9JfXvYkbPQ4zD2YqYd&ust=1647847506256000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCPCVgL2U1PYCFQAAAAAdAAAAABAD'
                  },new SetOptions(merge: true));
  }

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: _email!, password: _password!);
            User? user = result.user;
            user!.updateDisplayName(_name);
            addUserData(user);
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  void showError(String errormessage) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
           theme: ThemeData(
             primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(18, 23, 64, 1),
            automaticallyImplyLeading: true,
            title:  const Text('Deliciouslyyy'),
            leading: IconButton(icon:const Icon(Icons.arrow_back),
              onPressed: () =>Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                    builder: (context) => const Start()))
            ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child : Form( 
            key:_formKey,
            child:Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
            
                SizedBox(
                  height: 100,
                  child: Image.asset('assets/cooking_logo.png')
                ),
            
                const SizedBox(
                  height: 40,
                ),
            
                TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Enter Name';
                    }
                  },
                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.email)),
                  onSaved:(newValue) {
                    _name = newValue!;
                  },
            
                ),
                TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                  },
                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email)),
                  onSaved:(newValue) {
                    _email = newValue!;
                  },
            
                ),
                
                TextFormField(
                  validator: (value) {
                    if(value == null || value.length < 6) {
                      return 'Provide min 6 characters';
                    }
                  },
                  decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                  obscureText: true,
                  onSaved: (newValue) => _password = newValue!,
                ),
                const SizedBox(
                  height:30,
                ),
                StyledButton(
                  color: const Color.fromRGBO(18, 23, 64, 1),
                  child: const Text('Signup', 
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: signUp,
                ),
              ],),
            )
          ),
          ),
        )
      ),
    );
  }
}
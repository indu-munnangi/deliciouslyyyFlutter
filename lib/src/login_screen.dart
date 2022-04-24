import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'start_screen.dart';
import 'widgets.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   String _email='', _password = '';

  Future<void> checkAuthentication() async{
    _auth.authStateChanges().listen((user) { 
      if(user != null){
        Navigator.push<void>(context, MaterialPageRoute(builder: (context)=> const Home()));
      }
    });
  }
    
  
  @override
  void initState(){
    super.initState();
    checkAuthentication();
  } 
  

  Future<void> login() async {
    if(_formKey.currentState!.validate()){

      _formKey.currentState!.save();

      try{
          await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      }catch(e){
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
            title: const Text('Deliciouslyyy'),
            leading: IconButton(icon: const Icon(Icons.arrow_back),
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
                  child: const Text('Login', 
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: login,
                )
              ],),
            )
          ),
          ),
        )
      ),
    );
  }
}
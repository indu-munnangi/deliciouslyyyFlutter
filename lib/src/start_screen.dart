
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'widgets.dart';


class Start extends StatefulWidget {
  const Start({ Key? key }) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> googleSignIn() async {

    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user = await _auth.signInWithCredential(credential);

        Navigator.push<void>(context, MaterialPageRoute(builder: (context)=> const Home()));
        if(user.additionalUserInfo!.isNewUser) await addUserData(user.user!.uid, user.user!.providerData[0]);
        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else {
      throw StateError('Sign in Aborted');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 23, 64, 1),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            
            SizedBox(
              height: 60,
              child: Image.asset('assets/cooking_logo.png')
            ),

            // const Text('Deliciouslyyy',style: TextStyle(
            //   color: Colors.white,
            //   fontSize: 30,
            //   ),
            // ),

            const SizedBox(
              height: 30,
            ),

            StyledButton(
              color: Colors.white,
              child: const Text('Login', 
              style: TextStyle(color: Color.fromRGBO(18, 23, 64, 1),fontSize: 20)), 
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                      builder: (context) => const Login()
                  )
              )
            ),

            StyledButton(
              color: const Color.fromRGBO(18, 23, 64, 1),
              child: const Text('SignUp', 
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                      builder: (context) => const Signup()
                  )
              )
            ),
          
            Row(
              children: [
                Expanded( 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:50.0,vertical: 15),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.25),
                      child: SignInButton(    
                        Buttons.Google,
                        padding: const EdgeInsets.all(10),
                        onPressed: googleSignIn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80)
                        ),  
                      ),
                    ),
                  ),
                ),
              ],
            )
            
          ],
        )
      ),
    );
  }

  Future addUserData (String Uid, UserInfo providerData) async {


        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference _users = firestore.collection('users');
        _users.doc(Uid).set(
          {
                  'name' : providerData.displayName,
                  'user_id' : Uid,
                  'user_role': 'customer',
                  'email':providerData.email,
                  'tis': DateTime.now().millisecondsSinceEpoch,
                  'imageUrl': providerData.photoURL == null?'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Davatar&psig=AOvVaw36Ph9JfXvYkbPQ4zD2YqYd&ust=1647847506256000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCPCVgL2U1PYCFQAAAAAdAAAAABAD' : providerData.photoURL,
                  },new SetOptions(merge: true));
  }

  
}

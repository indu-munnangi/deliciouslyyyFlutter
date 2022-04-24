// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'start_screen.dart';

class SplashScreen extends StatefulWidget{
    const SplashScreen({Key? key}) : super(key: key);
    @override
    _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  
@override
  void initState() {
    super.initState();
     Timer(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => const Start()
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 23, 64, 1),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                Image.asset('assets/cooking_logo.png'),
                SizedBox(
                  height: 20,
                ),
                Text('Deliciouslyyy', style: TextStyle(color:Colors.white,fontSize: 35,fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}

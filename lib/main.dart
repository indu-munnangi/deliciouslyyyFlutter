import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './firebase_options.dart';
import 'src/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
          focusColor: const Color.fromRGBO(18, 23, 64, 1),
          primaryColor:  const Color.fromRGBO(18, 23, 64, 1),
          inputDecorationTheme:  const InputDecorationTheme(
                    prefixIconColor:  Color.fromRGBO(18, 23, 64, 1),
      focusColor: Color.fromRGBO(18, 23, 64, 1),
      hoverColor: Color.fromRGBO(18, 23, 64, 1)
      ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),      
    );
  }
}



import 'package:flutter/material.dart';

class AddRecipesPage extends StatefulWidget {
  const AddRecipesPage({Key? key}) : super(key: key);

  @override
  State<AddRecipesPage> createState() => _AddRecipesPageState();
}

class _AddRecipesPageState extends State<AddRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         SizedBox(
                  height: 100,
                  child: Image.asset('assets/cooking_logo.png')
                ),
        Text(
            'This feature is not available in mobile app. Please login to web app deliciouslyyy.com and add your recipes',
            style: TextStyle(
                color: Colors.indigo,
                fontSize: 20,
                fontWeight: FontWeight.bold),
                	textAlign: TextAlign.center,

                
                ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';

class EditRecipePage extends StatefulWidget {
  const EditRecipePage({ Key? key }) : super(key: key);

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(child: Text('Edit recipe Page')),
    );
  }
}
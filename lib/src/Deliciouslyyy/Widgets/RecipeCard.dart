import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/RecipePage.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/models/RecipeModel.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/services/RemoteCalls.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/utils/util.dart';

class RecipeCard extends StatefulWidget {
  Recipe? recipe;
  var heading;
  var url;
  var supportingText;
  var isFav;
  Function triggerUpdate;
  Tabs? tab;
  RecipeCard({
    Key? key,
    this.recipe,
    required this.heading,
    required this.url,
    required this.supportingText,
    required this.isFav,
    required this.triggerUpdate,
    this.tab,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool? toggle;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
    toggle = widget.isFav;
   // print("toggle ${toggle}");
  }

 void getUser() {
    User? _localuser = _auth.currentUser;
    _localuser?.reload();
    if (_localuser != null) {
      setState(() {
        user = _localuser;
      });
    }
  }

  saveRecipe() async{
    await RemoteCalls().saveRecipe(widget.recipe!.id!, user!.uid);
    await widget.triggerUpdate();
  }

  unSaveRecipe() async{
    await RemoteCalls().unSaveRecipe(widget.recipe!.id!, user!.uid);
    await widget.triggerUpdate();
  }

  deleteRecipe() async{
    //print("deleteRecipe: "+widget.recipe!.id!);
    await RemoteCalls().deleteRecipe(widget.recipe!.id!);
    await widget.triggerUpdate();
  }

  Widget TrailingWidget() {
    if (widget.tab == Tabs.MyRecipes) {
      return SizedBox(
        width: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   child: IconButton(
            //     iconSize: 20,
            //     padding: EdgeInsets.only(right: 30.0),
            //     icon: Icon(Icons.edit),
            //     onPressed: () {
            //       /* ... */ print('Edit clicked');
            //     },
            //   ),
            // ),
            Expanded(
              child: IconButton(
                iconSize: 20,
                padding: EdgeInsets.only(left: 0.0),
                icon: Icon(Icons.delete),
                onPressed: () {
                  print('Delete clicked');
                  deleteRecipe();
                },
              ),
            ),
          ],
        ),
      );
    }
    else if(widget.tab == Tabs.SavedRecipes){

      return SizedBox(
      width: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: IconButton(
              iconSize: 20,
              padding: EdgeInsets.only(right: 30.0),
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                print('Unsave clicked to unsave');
                unSaveRecipe();                
              },
            ),
          ),
        ],
      ),
    );
    }
    return SizedBox(
      width: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: IconButton(
              iconSize: 20,
              padding: EdgeInsets.only(right: 30.0),
              icon: toggle!
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border, color: Colors.red),
              onPressed: () {
                setState(() {
                  toggle = !toggle!;
                  // print(toggle);
                });
                if(toggle!){
                      print('Save recipe');
                      saveRecipe();
                }else{
                    print('Unsave recipe');
                    unSaveRecipe();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Recipe recipe;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: GestureDetector(
            onTap: () {
              print('Card clicked');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RecipePage(recipe: widget.recipe!);
              }));
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.heading,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.supportingText, overflow: TextOverflow.ellipsis, maxLines: 3),
                          TrailingWidget(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // CircleAvatar(radius: 50.0, child: Image.asset('assets/me.png')
                      CircleAvatar(
                        radius: 50.0,
                        child: ClipRRect(
                          child: Image(
                              image: Image.memory(base64Decode(
                                      widget.url.toString().substring(22)))
                                  .image,
                              fit: BoxFit.none),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      
                ],
              ),
            ),
          )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/utils/util.dart';

import 'Widgets/RecipeCard.dart';
import 'models/RecipeModel.dart';
import 'services/RemoteCalls.dart';

class MySavedRecipes extends StatefulWidget {
  const MySavedRecipes({ Key? key }) : super(key: key);

  @override
  State<MySavedRecipes> createState() => _MySavedRecipesState();
}

class _MySavedRecipesState extends State<MySavedRecipes> {

  List<Recipe>? recipes;
  var isLoaded = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
    getSavedRecipes();
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

  getSavedRecipes() async {
    List<Recipe>? r= await RemoteCalls().getSavedRecipes(user!.uid);
    // if(recipes != null){
      setState(() {
        recipes = r != null ? r : [];
        isLoaded = true;
      });
    // }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: isLoaded,
            replacement: const Center(child:CircularProgressIndicator()),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.builder(
                      itemCount: recipes?.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 16),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,int index){
                        return new RecipeCard(
                          recipe: recipes![index],
                          heading: recipes![index].name,//"Fruit custard",
                          url:recipes![index].imagesList?[0].thumbUrl, 
                          supportingText: recipes![index].shortdesc,
                          isFav: false,
                          triggerUpdate: getSavedRecipes,
                          tab: Tabs.SavedRecipes);
                      },
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Visibility( 
              visible: isLoaded && recipes?.length == 0, 
              child: Text("No Saved Recipes"),),
          )
        ],
      ),
    );
  }
}
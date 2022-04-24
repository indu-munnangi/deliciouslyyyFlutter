import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/services/RemoteCalls.dart';

import 'Widgets/RecipeCard.dart';
import 'models/RecipeModel.dart';

class InitialAllRecipesPage extends StatefulWidget {
  const InitialAllRecipesPage({ Key? key }) : super(key: key);

  @override
  State<InitialAllRecipesPage> createState() => _InitialAllRecipesPageState();
}


class _InitialAllRecipesPageState extends State<InitialAllRecipesPage> {

  
  List<Recipe>? recipes;
  List<Recipe>? savedRecipes;
  var isLoaded = false;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;



  @override
  void initState() {
    super.initState();
    getUser();
    getAllRecipes();
    

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

  getRecipes() async{

    recipes = await RemoteCalls().getRecipes(user!.uid);
    //print(recipes!.length);
    if(recipes != null){
      setState(() {
        isLoaded = true;
      });
    }

  }

 getSavedRecipes() async {
    List<Recipe>? r = await RemoteCalls().getSavedRecipes(user!.uid);
    setState(() {
      savedRecipes = (r != null) ? r : [];;
    });
  }

  getAllRecipes() async{
    print(user);
    recipes = await RemoteCalls().getAllRecipes();
    // print(recipes!.length);
    if(recipes != null){
      await getSavedRecipes();
      setState((){
        isLoaded = true;
      });
    }
  }

  bool checkIsSaved(Recipe recipe){
      bool isFav = false;
      if(savedRecipes == null) return false;
      int n = savedRecipes!.length;
      for(int i = 0; i<n;i++){
           if (savedRecipes![i].id == recipe.id ){
             isFav =  true;
           };
      }
      return isFav;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
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
                      heading: recipes![index].name,
                      url:recipes![index].imagesList?[0].thumbUrl, 
                      supportingText: recipes![index].shortdesc,
                      isFav: checkIsSaved(recipes![index]),
                      triggerUpdate: getSavedRecipes,
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

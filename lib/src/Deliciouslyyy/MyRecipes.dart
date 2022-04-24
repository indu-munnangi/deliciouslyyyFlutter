import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/services/RemoteCalls.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/utils/util.dart';
import 'Widgets/RecipeCard.dart';
import 'models/RecipeModel.dart';

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({ Key? key }) : super(key: key);

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {

  List<Recipe>? recipes;
  var isLoaded = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
    getRecipes();
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
    List<Recipe>? r = await RemoteCalls().getRecipes(user!.uid);
      setState(() {
        recipes = r != null ? r : [];
        isLoaded = true;
      }); 
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
                          triggerUpdate: getRecipes,
                          tab: Tabs.MyRecipes);
                      },
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Visibility( 
              visible: isLoaded && recipes?.length == 0, 
              child: Text("You have not added any Recipes"),),
          )
        ],
      ),
    );
  }
}
// https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/recipes


import 'package:gtk_flutter/src/Deliciouslyyy/models/RecipeModel.dart';
import 'package:http/http.dart' as http;

class RemoteCalls{

  Future<List<Recipe>?> getAllRecipes() async{

    var client = http.Client();
    var uri = Uri.parse("https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/recipes");
    var response = await client.get(uri);
    if(response.statusCode == 200){
            print('success');

      var json = response.body;
      return recipeFromJson(json);
    }else{
      print('failed to get All recipes');
    }
  }

  Future<List<Recipe>?> getRecipes(String userId) async{

    var client = http.Client();
    var uri = Uri.parse("https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/recipesof/"+userId);
    var response = await client.get(uri);
    if(response.statusCode == 200){
            print('success');

      var json = response.body;
      return recipeFromJson(json);
    }else{
      print('failed');
      // return Error()
    }
  }

  Future<List<Recipe>?> getSavedRecipes(String userId) async{

    var client = http.Client();
    var uri = Uri.parse("https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/savedrecipes/"+userId);
    var response = await client.get(uri);
    if(response.statusCode == 200){
            print('success getSavedRecipes');

      var json = response.body;
      return recipeFromJson2(json);
    }else{
      print('failed getSavedRecipes');
      // return Error()
    }
  }


  Future<void> saveRecipe(String recipeId, String userId) async{

    var client = http.Client();
   
    var uri = Uri.parse("https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/saverecipe/");
    
    var response = await client.post(uri,body: {
        "recipeid": recipeId,
        "querieduserid": userId
    });

    if(response.statusCode == 200){
            print('successfully saved');
    }else{
      print('failed to save');
    }

  }

  Future<void> unSaveRecipe(String recipeId, String userId) async{

    var client = http.Client();
   
    var uri = Uri.parse("https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/unSaveRecipe/"+recipeId+"/"+userId);
    
    var response = await client.delete(uri);
  
    if(response.statusCode == 200){
            print('successfully unsaved');
    }else{
      print('failed to unsave');
    }

  }

  Future<void> deleteRecipe(String recipeId) async{

    var client = http.Client();
   
    var uri = Uri.parse("https://w1ldx49662.execute-api.us-east-1.amazonaws.com/dev/api/recipe/"+recipeId);
    
    var response = await client.delete(uri);
    print(response.body);
    if(response.statusCode == 200){
            print('successfully deleteRecipe');
    }else{
      print(response.statusCode);
    }

  }
}
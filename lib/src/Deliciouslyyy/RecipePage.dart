import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/InitialAllRecipesPage.dart';
import 'package:gtk_flutter/src/Deliciouslyyy/models/RecipeModel.dart';

import '../home_screen.dart';

class RecipePage extends StatefulWidget {
  Recipe recipe;
  RecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(18, 23, 64, 1),
          automaticallyImplyLeading: true,
          title: const Text('Recipe details'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute<void>(builder: (context) => const Home()))
                  
                  ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder:
              (BuildContext context, bool innerViewIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RecipeImage(widget.recipe.imagesList!),
                      RecipeTitle(widget.recipe),
                    ],
                  ),
                ),
                expandedHeight: 300.0,
                pinned: true,
                floating: true,
                //elevation: 5.0,
                forceElevated: innerViewIsScrolled,
                bottom: TabBar(
                  labelColor: Colors.indigo,
                  tabs: <Widget>[
                    // text: 'Ingredients'
                    // text: 'Preparation',c
                    Tab( child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: Image.asset('assets/ingredients.png').image,
                          height: 25,
                        ),
                        SizedBox(width:10),
                        Text("Ingredients"),
                      ],
                    )),
                    Tab( child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: Image.asset('assets/cooking.png').image,
                          height: 25,
                        ),
                        SizedBox(width:10),
                        Text("Preparation"),
                      ],
                    )),
                    // Tab( child: Image.asset('assets/cooking.png')),
                    
                  ],
                  controller: _tabController,
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              IngredientsView(widget.recipe.ingredients),
              PreparationView(widget.recipe.description),
            ],
            controller: _tabController,
          ),
        ));
  }
}

class IngredientsView extends StatelessWidget {
  final List<String> ingredients;

  IngredientsView(this.ingredients);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
          itemCount: ingredients.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
              child: Row(
                children: <Widget>[
                  Icon(Icons.circle, size: 8,),
                  SizedBox(width: 10.0),
                  Expanded(child: Text(ingredients[index])),
                ],
              ),
            );
          }),
    );
  }
}

class PreparationView extends StatelessWidget {
  final String preparationSteps;

  PreparationView(this.preparationSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = [];
    textElements.add(
      Html(data: preparationSteps)
      // Text(preparationSteps),
    );
    // Add spacing between the lines:
    textElements.add(
      SizedBox(
        height: 10.0,
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}

class RecipeImage extends StatelessWidget {
  final List<ImagesList> images;

  RecipeImage(this.images);

  @override
  Widget build(BuildContext context) {
    List<String?> imageUrls = [];
    for (int i = 0; i < images.length; i++) {
      imageUrls.add(images[i].thumbUrl);
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        // autoPlay: false,
      ),
      items: imageUrls
          .map((item) => Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        Image.memory(base64Decode(item!.substring(22))).image,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class RecipeTitle extends StatelessWidget {
  final Recipe recipe;

  RecipeTitle(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_app/components/recipe_card.dart';
import 'package:recipe_app/pages/favorite_recipe_page.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/pages/recipe_detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/pages/search_page.dart';



//https://api.edamam.com/api/recipes/v2?app_id=e0f14f27&app_key=76251ca17a2eab8d0afbe35df66e5ab1&q=salad&type=public
class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final String apiKey = '76251ca17a2eab8d0afbe35df66e5ab1';
  final String appId = 'e0f14f27';
  var url =
      'https://api.edamam.com/api/recipes/v2?app_id=e0f14f27&app_key=76251ca17a2eab8d0afbe35df66e5ab1&q=salad&type=public'; //&from=0&to=100&calories=591-722&health=alcohol-free

  List<RecipeModel> recipeList = [];

  getRecipeData() async {
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);

    json['hits'].forEach((recipe) {
      RecipeModel recipeModel = RecipeModel(
          image: recipe['recipe']['image'],
          source: recipe['recipe']['source'],
          label: recipe['recipe']['label'],
          ingredientLines: (recipe['recipe']['ingredientLines'] ?? []) as List);
      setState(() {
        recipeList.add(recipeModel);
      });
    });

    debugPrint(response.body);
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRecipeData();
  }

  String recipeName = 'TEST';
  String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Recipe'),
        centerTitle: true,
        backgroundColor: Colors.red.withOpacity(0.7),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteRecipePage()));
            },
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: recipeList.length,
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final recipeData = recipeList[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(
                                      recipeName: recipeData.label.toString(),
                                      image: recipeData.image.toString(),
                                      ingredientLines:
                                          recipeData.ingredientLines.toList(),
                                    )));
                      },
                      child: RecipeCard(recipeData: recipeData),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

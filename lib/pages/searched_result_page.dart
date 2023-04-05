import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/pages/recipe_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

class SearchedResultPage extends StatefulWidget {
  const SearchedResultPage({
    Key? key,
  }) : super(key: key);

  @override
  _SearchedResultPageState createState() => _SearchedResultPageState();
}

class _SearchedResultPageState extends State<SearchedResultPage> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      print(isLoading);
      getRecipeData();
      isLoading = false;
    });
  }

  List<RecipeModel> searchedRecipeList = [];

  // var url =
  //     'https://api.edamam.com/api/recipes/v2?app_id=e0f14f27&app_key=76251ca17a2eab8d0afbe35df66e5ab1&q=${this.query}&type=public'; //&from=0&to=100&calories=591-722&health=alcohol-free

  getRecipeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? query = prefs.getString('searchedElement');

    var response = await http.get(Uri.parse(
        'https://api.edamam.com/api/recipes/v2?app_id=e0f14f27&app_key=76251ca17a2eab8d0afbe35df66e5ab1&from=20&to=100&q=$query&excluded=$query&count=100&type=public'));
    Map json = jsonDecode(response.body);

    json['hits'].forEach((recipe) {
      RecipeModel recipeModel = RecipeModel(
          image: recipe['recipe']['image'],
          source: recipe['recipe']['source'],
          label: recipe['recipe']['label'],
          ingredientLines: recipe['recipe']['ingredientLines']);
      setState(() {
        searchedRecipeList.add(recipeModel);
      });
    });

    debugPrint(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Search Results'),
        centerTitle: true,
        backgroundColor: Colors.red.withOpacity(0.7),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: searchedRecipeList.length,
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final recipeData = searchedRecipeList[index];
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeDetailPage(
                                              recipeName:
                                                  recipeData.label.toString(),
                                              image:
                                                  recipeData.image.toString(),
                                          ingredientLines: recipeData.ingredientLines.toList(),

                                            )));
                              },
                              child: Container(
                                //padding: EdgeInsets.all(10),
                                //height: 180,
                                //width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${recipeData.image}',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                // child: Image.asset(
                                //   '${space!.image}',
                                //   height: 180,
                                //   width: 160,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              '${recipeData.label}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Source: ${recipeData.source}",
                            style: const TextStyle(),
                          ),
                        ],
                      );
                    }
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

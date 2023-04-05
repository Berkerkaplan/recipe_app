import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/favorite_model.dart';
import 'package:recipe_app/models/favorite_modell.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeName;
  final String image;
  final bool? isFavorite;
  final List? ingredientLines;

  const RecipeDetailPage(
      {Key? key,
      required this.recipeName,
      required this.image,
      this.isFavorite,
      this.ingredientLines})
      : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Box<FavoriteModel>? favoriteBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favoriteBox = Hive.box<FavoriteModel>('favoriteBox');
  }

  void _shareWithFriends() async {
    var gitHubLink = 'https://github.com/Berkerkaplan';
    await Share.share('Share with Your Friends \n\n $gitHubLink');
  }

  List favoriteList = [];

//  bool? saved =false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Recipe Detail'),
          centerTitle: true,
          backgroundColor: Colors.red.withOpacity(0.7),
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: SlidingUpPanel(
          minHeight: (size.height / 2),
          maxHeight: (size.height / 1.2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          parallaxEnabled: true,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image(
                    height: (size.height / 2 + 10),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.image),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<FavoriteProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      bool saved = context
                          .watch<FavoriteProvider>()
                          .favoriteList
                          .any((element) =>
                              element.recipeName == widget.recipeName);
                      print('bool $saved');
                      return IconButton(
                        onPressed: () {
                          final provider = Provider.of<FavoriteProvider>(
                              context,
                              listen: false);
                          final isFavorite =
                              provider.toggleFavoriteStatus(saved);

                          if (isFavorite) {
                            final favorite = FavoriteModell(
                              recipeName: widget.recipeName.toString(),
                              image: widget.image.toString(),
                              isFavorite: true,
                              ingredients: widget.ingredientLines,
                            );
                            setState(() {
                              saved = isFavorite;
                              print('if $saved');
                            });
                            Utils.showSnackBar(context, 'Recipe Successfully Added');

                            provider.addFavoriteList(favorite);
                          } else {
                            final favorite = FavoriteModell(
                              recipeName: widget.recipeName.toString(),
                              image: widget.image.toString(),
                              isFavorite: false,
                              ingredients: widget.ingredientLines,
                            );
                            setState(() {
                              value.favoriteList.removeWhere((element) =>
                                  element.recipeName == widget.recipeName);
                              provider.deleteFavoriteList(favorite);
                              saved = isFavorite;
                              print('else $saved');
                            });
                            Utils.showSnackBar(context, 'Recipe Successfully Removed');
                          }
                        },
                        icon: const Icon(
                          Icons.favorite,
                          shadows: <Shadow>[
                            Shadow(color: Colors.black, blurRadius: 7.5)
                          ],
                          size: 28,
                        ),
                        color: saved ? Colors.red : Colors.white,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 13,
                  right: 50,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    child: IconButton(
                      onPressed: () {
                        _shareWithFriends();
                      },
                       icon: const Icon(Icons.share,color: Colors.white,),
                    ),
                  ),
                ),
              ],
            ),
          ),
          panel: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(widget.recipeName),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.black.withOpacity(0.3),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.red,
                          tabs: [
                            Tab(
                              text: "Ingredients".toUpperCase(),
                            ),
                            Tab(
                              text: "Preparation".toUpperCase(),
                            ),
                          ],
                          labelColor: Colors.black,
                          indicator: DotIndicator(
                            color: Colors.black,
                            distanceFromCenter: 16,
                            radius: 3,
                            paintingStyle: PaintingStyle.fill,
                          ),
                          unselectedLabelColor: Colors.black.withOpacity(0.3),
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 32,
                          ),
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Ingredients(
                                ingredientLines: widget.ingredientLines!,
                              ),
                              //Ingredients(recipeModel: recipeModel),
                              Container(
                                child: const Text(
                                    "There is no Preparation in API response. Also I asked to you. You said you can put only ingredients"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Ingredients extends StatelessWidget {
  const Ingredients({
    Key? key,
    required this.ingredientLines,
  }) : super(key: key);
  final List ingredientLines;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: ingredientLines.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                  ),
                  child:
                      Text('👨‍🍳️ ' + '     ' + '${ingredientLines[index]}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black.withOpacity(0.3));
              },
            ),
          ],
        ),
      ),
    );
  }
}

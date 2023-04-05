import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/favorite_model.dart';
import 'package:recipe_app/models/favorite_modell.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/pages/recipe_detail_page.dart';
import 'package:recipe_app/utils.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteRecipePage extends StatefulWidget {
  const FavoriteRecipePage({Key? key}) : super(key: key);

  @override
  _FavoriteRecipePageState createState() => _FavoriteRecipePageState();
}

class _FavoriteRecipePageState extends State<FavoriteRecipePage> {
  Box<FavoriteModel>? favoriteBox;

  Utils utils = Utils();

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

  void deletedSnackbar() {
    Utils.showSnackBar(context, 'Favorite Recipe Successfully Deleted');
  }

  void deleteFavoriteItem(int key) {
    favoriteBox?.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Favorite Recipes'),
        centerTitle: true,
        backgroundColor: Colors.red.withOpacity(0.7),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: SafeArea(
        child: Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            final favoriteProvider =
                Provider.of<FavoriteProvider>(context, listen: false);
            final favoriteItems = favoriteProvider.favoriteList;
            return SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                reverse: true,
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  var key = favoriteItems[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(
                                    recipeName: key.recipeName.toString(),
                                    image: key.image.toString(),
                                    isFavorite: key.isFavorite,
                                    ingredientLines: key.ingredients!,
                                  )));
                    },
                    child: buildFavoriteCard(key, favoriteProvider, index),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  buildFavoriteCard(
      FavoriteModell key, FavoriteProvider favoriteProvider, int index) {
    return SingleChildScrollView(
      child: Slidable(
        key: Key(key.toString()),
        startActionPane: ActionPane(
          extentRatio: 0.5,
          motion: const StretchMotion(),
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                child: SlidableAction(
                  borderRadius: BorderRadius.circular(30),
                  onPressed: (BuildContext context) {
                    setState(() {
                      _shareWithFriends();
                    });
                  },
                  backgroundColor: Colors.green,
                  icon: Icons.share,
                  label: 'Share Your Friends',
                ),
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.5,
          motion: const StretchMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            setState(() {
              favoriteProvider.favoriteList.removeAt(index);
            });
            //deleteFavoriteItem(index);
            //favoriteModel.delete(index);
            deletedSnackbar();
          }),
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                child: SlidableAction(
                  borderRadius: BorderRadius.circular(30),
                  onPressed: (BuildContext context) {
                    setState(() {
                      favoriteProvider.favoriteList.removeAt(index);
                    });
                    //deleteFavoriteItem(index);
                    // favoriteModel.delete(key);
                    deletedSnackbar();
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.all(10),
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.red.withOpacity(0.7),
            image: DecorationImage(
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              image: NetworkImage(
                '${key.image.toString()}',
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              key.recipeName.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

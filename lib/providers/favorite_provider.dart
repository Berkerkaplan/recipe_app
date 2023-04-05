

import 'package:flutter/cupertino.dart';
import 'package:recipe_app/models/favorite_modell.dart';

class FavoriteProvider extends ChangeNotifier {
  List<FavoriteModell> favoriteList = [];

  List<FavoriteModell>? get favorites =>
      favoriteList.where((element) => element.isFavorite == true).toList();

  addFavoriteList(FavoriteModell favoriteModell) {


    favoriteList.add(favoriteModell);
    notifyListeners();
  }

  deleteFavoriteList(FavoriteModell favoriteModell) {
    favoriteList.remove(favoriteModell);
    notifyListeners();
  }

  bool toggleFavoriteStatus(bool isFavorite) {
    isFavorite = !isFavorite;
    //favoriteList.any((element) => element.isFavorite);

    notifyListeners();
    return isFavorite;
  }
}
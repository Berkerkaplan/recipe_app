import 'package:flutter/cupertino.dart';

class FavoriteModell {
  int? index;
  String? recipeName;
  String? image;
  bool isFavorite;
  List? ingredients;

  FavoriteModell(
      {this.recipeName,
      this.image,
      this.isFavorite = false,
      this.ingredients,
      this.index});
}



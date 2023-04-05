import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 1)
class FavoriteModel extends ChangeNotifier{
  @HiveField(0)
  String? recipeName;
  @HiveField(1)
  bool isFavorite;
  @HiveField(2)
  String? image;



  FavoriteModel({
    required this.recipeName,
    required this.isFavorite,
    required this.image,

  });
}
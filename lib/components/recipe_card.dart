import 'package:flutter/material.dart';

import '../models/recipe_model.dart';



class RecipeCard extends StatelessWidget {
  const RecipeCard({
  super.key,
  required this.recipeData,
  });

  final RecipeModel recipeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
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
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0),
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
}
class RecipeModel {
  String? label;
  String? image;
  String? source;
  List ingredientLines;

  RecipeModel({
    this.label,
    this.image,
    this.source,
    required this.ingredientLines,
  });

  factory RecipeModel.fromJson(Map<String,dynamic> json) => RecipeModel(
      label: json["label"],
      image: json["image"],
      source: json["source"],
      ingredientLines: json["ingredientLines"]
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "image": image,
    "source": source,
    "ingredientsLines": ingredientLines,

  };
}
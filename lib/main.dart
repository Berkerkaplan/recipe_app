import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/favorite_model.dart';
import 'package:recipe_app/models/favorite_modell.dart';
import 'package:recipe_app/providers/favorite_provider.dart';

import 'package:recipe_app/pages/recipe_page.dart';
import 'package:recipe_app/models/suggestion_history.dart';

Box<SuggestionHistory>? suggestionBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter<SuggestionHistory>(SuggestionHistoryAdapter());
  await Hive.openBox<SuggestionHistory>('suggestionBox');
  Hive.registerAdapter<FavoriteModel>(FavoriteModelAdapter());
  await Hive.openBox<FavoriteModel>('favoriteBox');
  //suggestionBox?.put('suggestionHistory', SuggestionHistory(searchHistory: 'Search For Recipe and Ingredients'));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(),
        ),
      ],
    child: MyApp(),),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipePage(),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/pages/searched_result_page.dart';
import 'package:recipe_app/models/suggestion_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Box<SuggestionHistory>? suggestionBox;

  @override
  void initState() {
    super.initState();
    suggestionBox = Hive.box<SuggestionHistory>('suggestionBox');
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.red.withOpacity(0.7),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Container(
          decoration: BoxDecoration(
              color: Colors.red.shade200,
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            controller: searchController,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Search for Recipe Ingredients...',
              contentPadding: EdgeInsets.all(8),
            ),
            onSubmitted: (value) async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('searchedElement', value);
              setState(() {
                SuggestionHistory suggestionHistory =
                    SuggestionHistory(searchHistory: searchController.text);
                suggestionBox?.add(suggestionHistory);



              debugPrint(searchController.text.toString());
                searchController.clear();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchedResultPage()));
              });

            },
            textInputAction: TextInputAction.search,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (searchController.text.isEmpty) {
                Navigator.pop(context);
              } else {
                searchController.clear();
              }
            },
            icon: const Icon(Icons.clear),
          ),
        ],

      ),
      body: ValueListenableBuilder(
        valueListenable: suggestionBox!.listenable(),
        builder: (context, Box<SuggestionHistory> suggestionHistories, child) {
          List<int> keys = suggestionHistories.keys.cast<int>().toList();

          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final int key = keys[index];
                final SuggestionHistory? suggestionHistory =
                    suggestionHistories.get(key);

                  return GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('searchedElement', key.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchedResultPage()));
                    },
                    child: ListTile(
                      title: Text('${suggestionHistory?.searchHistory}'),
                      trailing: IconButton(
                        onPressed: () {
                          suggestionHistories.delete(key);
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      leading: const Icon(Icons.search),
                    ),
                  );


              });
        },
      ),
    );
  }
}

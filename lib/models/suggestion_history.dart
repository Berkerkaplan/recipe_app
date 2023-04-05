import 'package:hive/hive.dart';

part 'suggestion_history.g.dart';

@HiveType(typeId: 0)
class SuggestionHistory {
  SuggestionHistory({required this.searchHistory});

  @HiveField(0)
  String searchHistory;

}
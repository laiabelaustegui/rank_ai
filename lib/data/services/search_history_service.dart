import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _keyRecentSearches = 'recent_searches';
  static const int _maxHistoryLength = 5;

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecentSearches) ?? [];
  }

  static Future<List<String>> saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyRecentSearches) ?? [];

    history.removeWhere(
      (item) => item.toLowerCase() == query.trim().toLowerCase(),
    );

    history.insert(0, query.trim());

    if (history.length > _maxHistoryLength) {
      history.removeRange(_maxHistoryLength, history.length);
    }

    await prefs.setStringList(_keyRecentSearches, history);
    return history;
  }

  static Future<List<String>> deleteSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyRecentSearches) ?? [];

    history.remove(query);
    await prefs.setStringList(_keyRecentSearches, history);
    return history;
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentSearches);
  }
}

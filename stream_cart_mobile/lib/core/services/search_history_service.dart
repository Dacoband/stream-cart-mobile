import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  Future<void> addSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = List<String>.from(_cachedHistory);
    
    // Remove if already exists
    history.remove(query);
    
    // Add to beginning
    history.insert(0, query);
    
    // Keep only max items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }
    
    _cachedHistory = history;
    await prefs.setStringList(_searchHistoryKey, history);
  }

  List<String> getSearchHistory() {
    // This should be synchronous, so we'll need to initialize it beforehand
    // For now return empty list, actual implementation would need async init
    return _cachedHistory;
  }

  static List<String> _cachedHistory = [];

  Future<void> initializeHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedHistory = prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> removeSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = List<String>.from(_cachedHistory);
    history.remove(query);
    _cachedHistory = history;
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedHistory = [];
    await prefs.remove(_searchHistoryKey);
  }
}

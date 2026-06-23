import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _keyRecentSearches = 'recent_searches';
  static const int _maxHistoryLength = 5; // Límite de elementos a guardar

  // Obtener la lista guardada
  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecentSearches) ?? [];
  }

  // Guardar una nueva búsqueda (poniéndola al principio)
  static Future<List<String>> saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyRecentSearches) ?? [];

    // Remover si ya existía para evitar duplicados y moverla arriba
    history.removeWhere(
      (item) => item.toLowerCase() == query.trim().toLowerCase(),
    );

    // Insertar al inicio de la lista
    history.insert(0, query.trim());

    // Recortar si supera el límite máximo
    if (history.length > _maxHistoryLength) {
      history.removeRange(_maxHistoryLength, history.length);
    }

    await prefs.setStringList(_keyRecentSearches, history);
    return history;
  }

  // Eliminar un elemento específico
  static Future<List<String>> deleteSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyRecentSearches) ?? [];

    history.remove(query);
    await prefs.setStringList(_keyRecentSearches, history);
    return history;
  }

  // 🛠️ NUEVO MÉTODO: Borra por completo la clave de búsquedas recientes
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentSearches);
  }
}

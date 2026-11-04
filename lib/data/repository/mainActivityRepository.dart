import 'package:shared_preferences/shared_preferences.dart';

class MainActivityRepository {
  static const String key = 'grid_items';
  static const String handymanKey = 'handyman_grid_items';

  static Future<void> savePositions(
    List<({String name, String icon})> items, {
    String storageKey = key,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      storageKey,
      items.map((item) => '${item.name}*${item.icon}').toList(),
    );
  }

  static Future<List<({String name, String icon})>> loadPositions(
    List<({String name, String icon})> defaultItems, {
    String storageKey = key,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedItems =
        prefs.getStringList(storageKey) ?? <String>[];

    // If no saved items, return empty list (will use default)
    if (savedItems.isEmpty) {
      return [];
    }

    // Parse saved items
    final List<({String name, String icon})> savedList = savedItems.map((i) {
      final parts = i.split('*');
      return (name: parts.first, icon: parts.last);
    }).toList();

    // Get set of saved item names for quick lookup
    final Set<String> savedNames = savedList.map((e) => e.name).toSet();
    final Set<String> defaultNames = defaultItems.map((e) => e.name).toSet();

    // Filter out items that no longer exist in defaults. Only the order is
    // taken from storage: a saved icon path breaks once the asset is renamed.
    final Map<String, String> defaultIcons = {
      for (final item in defaultItems) item.name: item.icon,
    };
    final List<({String name, String icon})> filteredSaved = savedList
        .where((item) => defaultNames.contains(item.name))
        .map((item) => (name: item.name, icon: defaultIcons[item.name]!))
        .toList();

    // Find new items that aren't in saved list and add them at the beginning
    final List<({String name, String icon})> newItems = defaultItems
        .where((item) => !savedNames.contains(item.name))
        .toList();

    // Return new items first, then saved items
    return [...newItems, ...filteredSaved];
  }
}

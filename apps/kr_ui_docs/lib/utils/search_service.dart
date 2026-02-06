import 'dart:async';
import 'package:flutter/foundation.dart';
import '../config/component_registry.dart';

/// Search result with relevance score
class SearchResult {
  final ComponentInfo component;
  final double relevance;
  final List<String> matchedFields;

  SearchResult({
    required this.component,
    required this.relevance,
    required this.matchedFields,
  });
}

/// Custom search service for component documentation with Isolate support
class SearchService {
  static Timer? _debounceTimer;

  /// Search components with debouncing using an isolate
  static Future<List<SearchResult>> search(
    String query, {
    Duration debounce = const Duration(milliseconds: 300),
  }) async {
    final completer = Completer<List<SearchResult>>();

    _debounceTimer?.cancel();

    _debounceTimer = Timer(debounce, () async {
      final results = await searchAsync(query);
      completer.complete(results);
    });

    return completer.future;
  }

  /// Perform search in a background isolate
  static Future<List<SearchResult>> searchAsync(String query) async {
    if (query.trim().isEmpty) return [];

    // Extract raw data for isolate to avoid complexity
    final components = ComponentRegistry.allComponents;

    return compute(_searchWorker, {
      'query': query,
      'components': components,
    });
  }

  /// Isolate worker function
  static List<SearchResult> _searchWorker(Map<String, dynamic> params) {
    final String query = params['query'] as String;
    final List<ComponentInfo> components =
        params['components'] as List<ComponentInfo>;

    final lowerQuery = query.toLowerCase();
    final results = <SearchResult>[];

    for (final component in components) {
      double score = 0.0;
      final List<String> matchedFields = [];

      // Check component name (highest weight)
      if (component.displayName.toLowerCase().contains(lowerQuery)) {
        score += 10.0;
        matchedFields.add('name');
      }

      // Check category
      if (component.category.toLowerCase().contains(lowerQuery)) {
        score += 5.0;
        matchedFields.add('category');
      }

      // Check description
      if (component.description.toLowerCase().contains(lowerQuery)) {
        score += 3.0;
        matchedFields.add('description');
      }

      // Check properties
      for (final prop in component.properties) {
        if (prop.name.toLowerCase().contains(lowerQuery) ||
            prop.description.toLowerCase().contains(lowerQuery)) {
          score += 2.0;
          if (!matchedFields.contains('properties')) {
            matchedFields.add('properties');
          }
        }
      }

      score += _fuzzyMatch(component.displayName.toLowerCase(), lowerQuery);

      if (score > 0) {
        results.add(SearchResult(
          component: component,
          relevance: score,
          matchedFields: matchedFields,
        ));
      }
    }

    results.sort((a, b) => b.relevance.compareTo(a.relevance));
    return results;
  }

  static double _fuzzyMatch(String text, String query) {
    if (text == query) return 5.0;
    if (text.startsWith(query)) return 4.0;

    int matches = 0;
    int queryIndex = 0;

    for (int i = 0; i < text.length && queryIndex < query.length; i++) {
      if (text[i] == query[queryIndex]) {
        matches++;
        queryIndex++;
      }
    }

    if (matches == query.length) {
      return 2.0 * (matches / text.length);
    }

    return 0.0;
  }

  /// Highlight matching text (sync is fine for small display strings)
  static String highlightMatch(String text, String query) {
    if (query.isEmpty) return text;

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) return text;

    final startIndex = lowerText.indexOf(lowerQuery);
    final endIndex = startIndex + query.length;

    return '${text.substring(0, startIndex)}**${text.substring(startIndex, endIndex)}**${text.substring(endIndex)}';
  }
}

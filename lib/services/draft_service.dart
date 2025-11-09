import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

/// Service for saving and loading quote drafts locally
/// Uses SharedPreferences to persist data on the device

class DraftService {
  static const String _draftsKey = 'quote_drafts';

  /// Save a quote as a draft
  Future<void> saveDraft(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing drafts
    final drafts = await getAllDrafts();

    // Check if quote already exists (update) or is new (add)
    final existingIndex = drafts.indexWhere((d) => d.id == quote.id);

    if (existingIndex != -1) {
      // Update existing draft
      drafts[existingIndex] = quote;
    } else {
      // Add new draft
      drafts.add(quote);
    }

    // Convert all drafts to JSON and save
    final draftsJson = drafts.map((q) => q.toMap()).toList();
    await prefs.setString(_draftsKey, jsonEncode(draftsJson));
  }

  /// Get all saved drafts
  Future<List<Quote>> getAllDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final draftsString = prefs.getString(_draftsKey);

    if (draftsString == null || draftsString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> draftsJson = jsonDecode(draftsString);
      return draftsJson.map((json) => Quote.fromMap(json)).toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  /// Delete a specific draft
  Future<void> deleteDraft(String quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final drafts = await getAllDrafts();

    // Remove the draft with matching ID
    drafts.removeWhere((draft) => draft.id == quoteId);

    // Save updated list
    final draftsJson = drafts.map((q) => q.toMap()).toList();
    await prefs.setString(_draftsKey, jsonEncode(draftsJson));
  }

  /// Load a specific draft
  Future<Quote?> loadDraft(String quoteId) async {
    final drafts = await getAllDrafts();
    try {
      return drafts.firstWhere((draft) => draft.id == quoteId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all drafts
  Future<void> clearAllDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftsKey);
  }
}

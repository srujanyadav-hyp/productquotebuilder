import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/quote.dart';
import '../models/quote_item.dart';

// This tells Riverpod to generate code for us
// It will create a file called quote_provider.g.dart automatically
part 'quote_provider.g.dart';

/// 🧠 THIS IS THE BRAIN OF OUR APP!
///
/// Think of this as a smart notebook that:
/// 1. Remembers the current quote
/// 2. Lets you modify it (add items, update client info, etc.)
/// 3. Automatically tells the UI when something changes
///
/// WHY USE RIVERPOD?
/// - Without it: Each screen would have its own copy of data (chaos!)
/// - With it: One central place holds the data, all screens share it

@riverpod
class QuoteNotifier extends _$QuoteNotifier {
  /// This is called when the provider is first created
  /// It returns the initial state (an empty quote)
  @override
  Quote build() {
    return Quote.empty();
  }

  // ========== CLIENT INFO METHODS ==========

  /// Update the client's name
  /// When user types in the name field, call this
  void updateClientName(String name) {
    state = state.copyWith(clientInfo: state.clientInfo.copyWith(name: name));
  }

  /// Update the client's address
  void updateClientAddress(String address) {
    state = state.copyWith(
      clientInfo: state.clientInfo.copyWith(address: address),
    );
  }

  /// Update the client's reference/contact
  void updateClientReference(String reference) {
    state = state.copyWith(
      clientInfo: state.clientInfo.copyWith(reference: reference),
    );
  }

  // ========== LINE ITEM METHODS ==========

  /// Add a new empty line item to the quote
  /// Like adding a new row in Excel
  void addItem() {
    final newItem = QuoteItem(
      productName: '',
      quantity: 1,
      rate: 0,
      discount: 0,
      taxPercent: 0,
    );

    // Create a new list with the existing items + new item
    final updatedItems = [...state.items, newItem];

    state = state.copyWith(items: updatedItems);
  }

  /// Remove an item at a specific index
  /// Like deleting a row in Excel
  void removeItem(int index) {
    // Safety check: don't allow removing the last item
    if (state.items.length <= 1) {
      return; // Keep at least one item
    }

    // Create a new list without the item at this index
    final updatedItems = List<QuoteItem>.from(state.items)..removeAt(index);

    state = state.copyWith(items: updatedItems);
  }

  /// Clear all fields of an item (reset to initial state)
  /// Used when there's only one item and user clicks the clear button
  /// Resets to default values: quantity=1, all others=0 or empty
  void clearItem(int index) {
    // Safety check: make sure index is valid
    if (index < 0 || index >= state.items.length) {
      return;
    }

    // Create a new item with initial/default values
    final clearedItem = QuoteItem(
      productName: '',
      quantity: 1, // Default quantity is 1
      rate: 0,
      discount: 0,
      taxPercent: 0,
    );

    // Replace the item at this index with the cleared one
    final updatedItems = List<QuoteItem>.from(state.items);
    updatedItems[index] = clearedItem;

    state = state.copyWith(items: updatedItems);
  }

  /// Update a specific field of a specific item
  /// index: which item (0, 1, 2, etc.)
  /// field: which property to update
  /// value: new value
  void updateItem(int index, String field, dynamic value) {
    // Safety check: make sure index is valid
    if (index < 0 || index >= state.items.length) {
      return;
    }

    // Get the current item
    final item = state.items[index];

    // Create an updated version of this item based on which field changed
    QuoteItem updatedItem;

    switch (field) {
      case 'productName':
        updatedItem = item.copyWith(productName: value as String);
        break;
      case 'quantity':
        updatedItem = item.copyWith(quantity: value as double);
        break;
      case 'rate':
        updatedItem = item.copyWith(rate: value as double);
        break;
      case 'discount':
        updatedItem = item.copyWith(discount: value as double);
        break;
      case 'taxPercent':
        updatedItem = item.copyWith(taxPercent: value as double);
        break;
      default:
        return; // Unknown field, do nothing
    }

    // Replace the old item with the updated one
    final updatedItems = List<QuoteItem>.from(state.items);
    updatedItems[index] = updatedItem;

    state = state.copyWith(items: updatedItems);
  }

  // ========== QUOTE MANAGEMENT ==========

  /// Reset to a new empty quote (like starting over)
  void resetQuote() {
    state = Quote.empty();
  }

  /// Load an existing quote (useful for editing saved quotes)
  void loadQuote(Quote quote) {
    state = quote;
  }

  /// Update quote status (Draft, Sent, Accepted)
  void updateStatus(String status) {
    state = state.copyWith(status: status);
  }
}

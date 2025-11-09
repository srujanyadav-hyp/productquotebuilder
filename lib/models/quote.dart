import 'client_info.dart';
import 'quote_item.dart';

/// This is the MAIN model that represents a complete quote
/// It contains client info + all line items + calculations

class Quote {
  String id; // Unique identifier for this quote
  ClientInfo clientInfo; // Who is this quote for?
  List<QuoteItem> items; // All the products/services in this quote
  DateTime createdDate; // When was this quote created?
  String status; // Draft, Sent, or Accepted

  // Constructor
  Quote({
    required this.id,
    required this.clientInfo,
    required this.items,
    required this.createdDate,
    this.status = 'Draft', // Default status is Draft
  });

  // Calculate the subtotal: sum of all item totals
  // This is like adding up all rows in a spreadsheet
  double get subtotal {
    // Start with 0, then add each item's total
    return items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  // Grand total - in this case, same as subtotal
  // But you could add additional charges here if needed
  double get grandTotal {
    return subtotal;
  }

  // Calculate total tax across all items
  double get totalTax {
    return items.fold(0.0, (sum, item) => sum + item.taxAmount);
  }

  // Calculate subtotal before tax
  double get subtotalBeforeTax {
    return items.fold(0.0, (sum, item) => sum + item.subtotalWithoutTax);
  }

  // Check if the quote has valid data
  bool get isValid {
    // Must have valid client info
    if (!clientInfo.isValid) return false;

    // Must have at least one item
    if (items.isEmpty) return false;

    // All items must have valid product names
    for (var item in items) {
      if (item.productName.trim().isEmpty) return false;
    }

    return true;
  }

  // Get specific validation error message
  String get validationMessage {
    // Check client info first
    if (!clientInfo.isValid) {
      return 'Please fill the Client Information';
    }

    // Check if there are any items
    if (items.isEmpty) {
      return 'Please add at least one line item';
    }

    // Check if all items have product names
    for (var i = 0; i < items.length; i++) {
      if (items[i].productName.trim().isEmpty) {
        return 'Please fill Item ${i + 1} information';
      }
    }

    return 'Quote is valid';
  }

  // Create a copy with some fields changed
  Quote copyWith({
    String? id,
    ClientInfo? clientInfo,
    List<QuoteItem>? items,
    DateTime? createdDate,
    String? status,
  }) {
    return Quote(
      id: id ?? this.id,
      clientInfo: clientInfo ?? this.clientInfo,
      items: items ?? this.items,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientInfo': clientInfo.toMap(),
      'items': items.map((item) => item.toMap()).toList(),
      'createdDate': createdDate.toIso8601String(),
      'status': status,
    };
  }

  // Create from Map
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] ?? '',
      clientInfo: ClientInfo.fromMap(map['clientInfo'] ?? {}),
      items:
          (map['items'] as List<dynamic>?)
              ?.map((item) => QuoteItem.fromMap(item))
              .toList() ??
          [],
      createdDate: DateTime.parse(
        map['createdDate'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'Draft',
    );
  }

  // Create an empty quote (useful for starting a new quote)
  factory Quote.empty() {
    return Quote(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), // Simple ID generation
      clientInfo: ClientInfo.empty(),
      items: [
        // Start with one empty item
        QuoteItem(
          productName: '',
          quantity: 1,
          rate: 0,
          discount: 0,
          taxPercent: 0,
        ),
      ],
      createdDate: DateTime.now(),
      status: 'Draft',
    );
  }
}

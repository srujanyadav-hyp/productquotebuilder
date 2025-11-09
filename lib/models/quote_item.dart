/// This file defines the structure of a single line item in our quote
/// Think of it like a row in an Excel spreadsheet for a product/service

class QuoteItem {
  // Each property stores a piece of information about the product

  String
  productName; // What are we selling? (e.g., "Laptop", "Consulting Service")
  double quantity; // How many? (e.g., 5 laptops, 10 hours of service)
  double rate; // Price per unit (e.g., 500 per laptop)
  double discount; // Money off (e.g., 50 discount per item)
  double taxPercent; // Tax amount (fixed amount, not percentage)

  // Constructor - this is called when creating a new QuoteItem
  // It's like filling out a form with all the details
  QuoteItem({
    required this.productName, // 'required' means you MUST provide this value
    required this.quantity,
    required this.rate,
    this.discount = 0.0, // Default to 0 if not provided (discount is optional)
    required this.taxPercent,
  });

  // This calculates the total for THIS SINGLE ITEM
  // Formula to calculate: ((rate - discount) * quantity) + tax
  // Tax is a FIXED AMOUNT, not a percentage!
  double get itemTotal {
    // Step 1: Calculate price after discount
    double priceAfterDiscount = rate - discount;

    // Step 2: Multiply by quantity to get subtotal
    double subtotal = priceAfterDiscount * quantity;

    // Step 3: Add tax amount (tax is already a fixed amount, not a percentage)
    return subtotal + taxPercent;
  }

  // This calculates just the subtotal without tax (useful for display)
  double get subtotalWithoutTax {
    return (rate - discount) * quantity;
  }

  // This returns the tax amount (it's already stored as a fixed amount)
  double get taxAmount {
    return taxPercent;
  }

  // Create a copy of this item with some fields changed
  // Useful when editing items without changing the original
  QuoteItem copyWith({
    String? productName,
    double? quantity,
    double? rate,
    double? discount,
    double? taxPercent,
  }) {
    return QuoteItem(
      productName:
          productName ?? this.productName, // Use new value OR keep old one
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      discount: discount ?? this.discount,
      taxPercent: taxPercent ?? this.taxPercent,
    );
  }

  // Convert this object to a Map (useful for saving to database or JSON)
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'rate': rate,
      'discount': discount,
      'taxPercent': taxPercent,
    };
  }

  // Create a QuoteItem from a Map (useful when loading from database or JSON)
  factory QuoteItem.fromMap(Map<String, dynamic> map) {
    return QuoteItem(
      productName: map['productName'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      rate: map['rate']?.toDouble() ?? 0.0,
      discount: map['discount']?.toDouble() ?? 0.0,
      taxPercent: map['taxPercent']?.toDouble() ?? 0.0,
    );
  }
}

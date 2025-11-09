/// This file defines the client/customer information structure
/// Like a business card with name, address, and contact details

class ClientInfo {
  String name; // Client's name (e.g., "John Doe" or "ABC Corporation")
  String address; // Client's full address (can be multiple lines)
  String reference; // Reference number, phone, or email (flexible field)

  // Constructor - creates a new ClientInfo object
  ClientInfo({
    required this.name,
    required this.address,
    required this.reference,
  });

  // Check if all required fields are filled
  // Returns true only if nothing is empty
  bool get isValid {
    return name.trim().isNotEmpty &&
        address.trim().isNotEmpty &&
        reference.trim().isNotEmpty;
  }

  // Create a copy with some fields updated
  ClientInfo copyWith({String? name, String? address, String? reference}) {
    return ClientInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      reference: reference ?? this.reference,
    );
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {'name': name, 'address': address, 'reference': reference};
  }

  // Create from Map when loading
  factory ClientInfo.fromMap(Map<String, dynamic> map) {
    return ClientInfo(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      reference: map['reference'] ?? '',
    );
  }

  // Create an empty ClientInfo (useful for initial form state)
  factory ClientInfo.empty() {
    return ClientInfo(name: '', address: '', reference: '');
  }
}

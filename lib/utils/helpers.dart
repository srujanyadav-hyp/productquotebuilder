import 'package:intl/intl.dart';

/// This file contains helper functions and constants used throughout the app
/// Think of it as a toolbox with useful tools

class AppConstants {
  // App information
  static const String appName = 'Product Quote Builder';
  static const String appVersion = '1.0.0';

  // Default values
  static const double defaultTaxPercent = 18.0; // Default GST in India
  static const int maxQuoteItems = 50; // Maximum items allowed in one quote

  // Status options
  static const String statusDraft = 'Draft';
  static const String statusSent = 'Sent';
  static const String statusAccepted = 'Accepted';

  static const List<String> statusOptions = [
    statusDraft,
    statusSent,
    statusAccepted,
  ];
}

/// Helper class for formatting numbers and currency
class FormatHelper {
  // Currency formatter - formats numbers like: ₹1,234.56
  static final NumberFormat currencyFormat = NumberFormat.currency(
    symbol: '₹', // Rupee symbol (you can change to $ or € etc.)
    decimalDigits: 2,
  );

  // Number formatter without currency symbol - formats like: 1,234.56
  static final NumberFormat numberFormat = NumberFormat('#,##0.00');

  // Percentage formatter - formats like: 18.00%
  static final NumberFormat percentFormat = NumberFormat('#0.00');

  /// Format a double value as currency
  /// Example: 1234.56 becomes "₹1,234.56"
  static String formatCurrency(double value) {
    return currencyFormat.format(value);
  }

  /// Format a double value as a plain number
  /// Example: 1234.56 becomes "1,234.56"
  static String formatNumber(double value) {
    return numberFormat.format(value);
  }

  /// Format a double value as percentage
  /// Example: 18 becomes "18.00%"
  static String formatPercent(double value) {
    return '${percentFormat.format(value)}%';
  }

  /// Parse a string to double, returns 0 if invalid
  /// Useful when reading user input from text fields
  static double parseDouble(String value) {
    try {
      // Remove any commas or currency symbols
      final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.parse(cleaned);
    } catch (e) {
      return 0.0; // Return 0 if parsing fails
    }
  }
}

/// Helper class for date formatting
class DateHelper {
  // Date formatter - formats like: Jan 15, 2024
  static final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

  // Date-time formatter - formats like: Jan 15, 2024 3:30 PM
  static final DateFormat dateTimeFormat = DateFormat('MMM dd, yyyy h:mm a');

  /// Format a DateTime as date only
  static String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  /// Format a DateTime with time
  static String formatDateTime(DateTime date) {
    return dateTimeFormat.format(date);
  }
}

/// Helper class for validation
class ValidationHelper {
  /// Check if a string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Check if a string is a valid number
  static bool isValidNumber(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    try {
      double.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if a number is positive
  static bool isPositive(double? value) {
    return value != null && value > 0;
  }

  /// Validate email format (basic validation)
  static bool isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }
}

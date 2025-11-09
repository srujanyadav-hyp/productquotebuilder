import 'package:flutter/material.dart';

/// App theme and color constants
/// This keeps all our colors and styles in one place for consistency

class AppTheme {
  // Primary colors - main brand colors
  static const Color primaryColor = Color(0xFF2196F3); // Professional blue
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // Accent colors
  static const Color accentColor = Color(0xFF4CAF50); // Green for success
  static const Color errorColor = Color(0xFFF44336); // Red for errors
  static const Color warningColor = Color(0xFFFF9800); // Orange for warnings

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Background colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Status colors
  static const Color statusDraft = Color(0xFF9E9E9E); // Grey
  static const Color statusSent = Color(0xFF2196F3); // Blue
  static const Color statusAccepted = Color(0xFF4CAF50); // Green

  /// Get color based on quote status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return statusSent;
      case 'accepted':
        return statusAccepted;
      default:
        return statusDraft;
    }
  }

  // Light theme for the app
  static ThemeData lightTheme = ThemeData(
    // Main colors
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Input decoration theme (for text fields)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Use Material 3
    useMaterial3: true,
  );
}

/// Spacing constants for consistent padding/margins
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Text styles for consistency
class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppTheme.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppTheme.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppTheme.textSecondary,
  );

  // Labels
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppTheme.textSecondary,
  );

  // Currency/numbers (right-aligned, monospace)
  static const TextStyle currency = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
    color: AppTheme.textPrimary,
  );
}

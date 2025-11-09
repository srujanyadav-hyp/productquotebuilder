import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/quote_form_screen.dart';
import 'utils/theme.dart';

/// This is the STARTING POINT of our app
/// Every Flutter app starts here with the main() function

void main() {
  // ProviderScope is the Riverpod container that holds all our state
  // It MUST wrap the entire app for Riverpod to work
  runApp(const ProviderScope(child: MyApp()));
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Product Quote Builder',

      // Remove debug banner in top-right corner
      debugShowCheckedModeBanner: false,

      // Apply our custom theme
      theme: AppTheme.lightTheme,

      // Set the home screen (first screen user sees)
      home: const QuoteFormScreen(),
    );
  }
}

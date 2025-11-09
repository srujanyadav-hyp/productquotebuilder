// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quoteNotifierHash() => r'169e682aacd8d270e4aa55535edbb2bb6ce05009';

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
///
/// Copied from [QuoteNotifier].
@ProviderFor(QuoteNotifier)
final quoteNotifierProvider =
    AutoDisposeNotifierProvider<QuoteNotifier, Quote>.internal(
      QuoteNotifier.new,
      name: r'quoteNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quoteNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuoteNotifier = AutoDisposeNotifier<Quote>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

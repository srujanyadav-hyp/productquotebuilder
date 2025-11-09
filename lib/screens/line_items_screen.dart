import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import '../widgets/quote_item_row.dart';
import 'quote_preview_screen.dart';

/// Dedicated screen for managing line items with better UX
/// Features:
/// - Floating action button for adding items
/// - Bottom bar with quote summary (always visible)
/// - Preview button in app bar
/// - Empty state with big add button

class LineItemsScreen extends ConsumerWidget {
  const LineItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteNotifier = ref.read(quoteNotifierProvider.notifier);
    final quote = ref.watch(quoteNotifierProvider);
    final items = quote.items;
    final hasItems = items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Line Items'),
        actions: [
          // Preview Quote button in app bar
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () {
                if (quote.isValid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuotePreviewScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(quote.validationMessage),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.visibility, color: Colors.white),
              label: const Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating action button for adding items
      floatingActionButton: hasItems
          ? FloatingActionButton.extended(
              onPressed: () => _addItem(context, quoteNotifier, items.length),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              backgroundColor: AppTheme.primaryColor,
            )
          : null,

      // Bottom navigation bar with quote summary
      bottomNavigationBar: hasItems ? _buildQuoteSummary(quote) : null,

      body: hasItems
          ? _buildItemsList(context, items, quoteNotifier)
          : _buildEmptyState(context, quoteNotifier),
    );
  }

  /// Build empty state with big add button
  Widget _buildEmptyState(BuildContext context, QuoteNotifier quoteNotifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large icon
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: Colors.grey[300],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'No Items Added Yet',
              style: AppTextStyles.heading2.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Subtitle
            Text(
              'Add products or services to your quote',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Big Add Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () => _addItem(context, quoteNotifier, 0),
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 32,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add Your First Item',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build scrollable list of items
  Widget _buildItemsList(
    BuildContext context,
    List items,
    QuoteNotifier quoteNotifier,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: 180, // Extra padding for bottom bar + FAB
      ),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return QuoteItemRow(
          key: ValueKey('item_$index'),
          index: index,
          item: items[index],
          totalItems: items.length,
          onRemove: () {
            // If it's the only item (first item when total is 1), clear it
            // Otherwise, remove it from the list
            if (index == 0 && items.length == 1) {
              quoteNotifier.clearItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item cleared'),
                  backgroundColor: AppTheme.accentColor,
                  duration: Duration(seconds: 1),
                ),
              );
            } else {
              quoteNotifier.removeItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item ${index + 1} removed'),
                  backgroundColor: AppTheme.errorColor,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Build quote summary bottom bar (scrollable)
  Widget _buildQuoteSummary(quote) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scrollable totals section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Subtotal
                _buildSummaryItem(
                  'Subtotal',
                  FormatHelper.formatCurrency(quote.subtotalBeforeTax),
                  Icons.calculate,
                  AppTheme.primaryColor,
                ),
                const SizedBox(width: AppSpacing.lg),

                // Tax
                _buildSummaryItem(
                  'Tax',
                  FormatHelper.formatCurrency(quote.totalTax),
                  Icons.account_balance,
                  AppTheme.warningColor,
                ),
                const SizedBox(width: AppSpacing.lg),

                // Grand Total (highlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'GRAND TOTAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        FormatHelper.formatCurrency(quote.grandTotal),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual summary item
  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color.withOpacity(0.7)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Add item with validation
  void _addItem(
    BuildContext context,
    QuoteNotifier quoteNotifier,
    int currentCount,
  ) {
    if (currentCount < AppConstants.maxQuoteItems) {
      quoteNotifier.addItem();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${AppConstants.maxQuoteItems} items allowed'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import 'quote_item_row.dart';

/// This widget displays the list of line items (products/services)
/// Think of it as the itemized list in an invoice

class QuoteItemsSection extends ConsumerWidget {
  const QuoteItemsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteNotifier = ref.read(quoteNotifierProvider.notifier);
    final quote = ref.watch(quoteNotifierProvider);
    final items = quote.items;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, color: AppTheme.primaryColor),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Line Items', style: AppTextStyles.heading3),
                  ],
                ),

                // Item count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length} item${items.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Header row (labels for columns)
            _buildHeaderRow(),

            const Divider(),

            // List of item rows
            ListView.separated(
              shrinkWrap: true, // Important: don't take infinite height
              physics:
                  const NeverScrollableScrollPhysics(), // Parent handles scrolling
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(),
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
            ),

            const SizedBox(height: AppSpacing.md),

            // Add Item button - Modern rectangular blue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (items.length < AppConstants.maxQuoteItems) {
                    quoteNotifier.addItem();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Maximum ${AppConstants.maxQuoteItems} items allowed',
                        ),
                        backgroundColor: AppTheme.warningColor,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  'Add Line Item',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the header row with column labels
  Widget _buildHeaderRow() {
    return Row(
      children: [
        // Product/Service column
        Expanded(
          flex: 3,
          child: Text(
            'Product/Service',
            style: AppTextStyles.label.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Qty column
        Expanded(
          flex: 1,
          child: Text(
            'Qty',
            style: AppTextStyles.label.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Rate column
        Expanded(
          flex: 1,
          child: Text(
            'Rate',
            style: AppTextStyles.label.copyWith(fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Discount column
        Expanded(
          flex: 1,
          child: Text(
            'Disc.',
            style: AppTextStyles.label.copyWith(fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Tax % column
        Expanded(
          flex: 1,
          child: Text(
            'Tax%',
            style: AppTextStyles.label.copyWith(fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Total column
        Expanded(
          flex: 1,
          child: Text(
            'Total',
            style: AppTextStyles.label.copyWith(fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),

        // Space for delete button
        const SizedBox(width: 40),
      ],
    );
  }
}

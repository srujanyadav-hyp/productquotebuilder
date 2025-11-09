import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';

/// This widget displays the calculated totals
/// Like the bottom section of an invoice showing subtotal, tax, and grand total

class QuoteTotalsSection extends ConsumerWidget {
  const QuoteTotalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteNotifierProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section title
            Row(
              children: [
                Icon(Icons.calculate, color: AppTheme.primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text('Quote Summary', style: AppTextStyles.heading3),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Subtotal before tax
            _buildTotalRow(
              label: 'Subtotal (before tax)',
              amount: quote.subtotalBeforeTax,
              isSubtotal: true,
            ),

            const SizedBox(height: AppSpacing.sm),

            // Total tax
            _buildTotalRow(
              label: 'Total Tax',
              amount: quote.totalTax,
              isSubtotal: true,
            ),

            const Divider(height: AppSpacing.lg),

            // Grand Total (highlighted)
            _buildTotalRow(
              label: 'Grand Total',
              amount: quote.grandTotal,
              isGrandTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Build a single total row
  Widget _buildTotalRow({
    required String label,
    required double amount,
    bool isSubtotal = false,
    bool isGrandTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isGrandTotal
              ? AppTextStyles.heading3
              : isSubtotal
              ? AppTextStyles.bodyMedium
              : AppTextStyles.bodyLarge,
        ),
        Container(
          padding: isGrandTotal
              ? const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                )
              : EdgeInsets.zero,
          decoration: isGrandTotal
              ? BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Text(
            FormatHelper.formatCurrency(amount),
            style: isGrandTotal
                ? AppTextStyles.currency.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  )
                : isSubtotal
                ? AppTextStyles.currency.copyWith(fontSize: 14)
                : AppTextStyles.currency,
          ),
        ),
      ],
    );
  }
}

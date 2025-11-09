import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote_item.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';

/// This widget represents a single line item row
/// Each row has: Product name, Qty, Rate, Discount, Tax%, Total, Delete button

class QuoteItemRow extends ConsumerWidget {
  final int index; // Which row is this? (0, 1, 2, etc.)
  final QuoteItem item; // The data for this row
  final VoidCallback onRemove; // Function to call when delete is clicked
  final int totalItems; // Total number of items in the list

  const QuoteItemRow({
    super.key,
    required this.index,
    required this.item,
    required this.onRemove,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteNotifier = ref.read(quoteNotifierProvider.notifier);

    // Check if we're on a small screen (mobile)
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    if (isSmallScreen) {
      // Mobile layout: stack fields vertically
      return _buildMobileLayout(quoteNotifier);
    } else {
      // Desktop/tablet layout: fields in a row
      return _buildDesktopLayout(quoteNotifier);
    }
  }

  /// Build layout for larger screens (desktop/tablet)
  Widget _buildDesktopLayout(QuoteNotifier quoteNotifier) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.dividerColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name field
          Expanded(flex: 3, child: _buildProductNameField(quoteNotifier)),
          const SizedBox(width: AppSpacing.sm),

          // Quantity field
          Expanded(flex: 1, child: _buildQuantityField(quoteNotifier)),
          const SizedBox(width: AppSpacing.sm),

          // Rate field
          Expanded(flex: 1, child: _buildRateField(quoteNotifier)),
          const SizedBox(width: AppSpacing.sm),

          // Discount field
          Expanded(flex: 1, child: _buildDiscountField(quoteNotifier)),
          const SizedBox(width: AppSpacing.sm),

          // Tax % field
          Expanded(flex: 1, child: _buildTaxField(quoteNotifier)),
          const SizedBox(width: AppSpacing.sm),

          // Total (calculated, non-editable)
          Expanded(flex: 1, child: _buildTotalDisplay()),

          // Delete/Clear button - show "Clear" button for first item when it's the only one
          SizedBox(
            width: (index == 0 && totalItems == 1) ? 80 : 48,
            child: (index == 0 && totalItems == 1)
                ? ElevatedButton(
                    onPressed: onRemove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppTheme.errorColor,
                    ),
                    onPressed: onRemove,
                    tooltip: 'Remove item',
                  ),
          ),
        ],
      ),
    );
  }

  /// Build layout for mobile screens (stacked vertically)
  Widget _buildMobileLayout(QuoteNotifier quoteNotifier) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.dividerColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row number and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              (index == 0 && totalItems == 1)
                  ? ElevatedButton(
                      onPressed: onRemove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.errorColor,
                      ),
                      onPressed: onRemove,
                      tooltip: 'Remove item',
                    ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Product Name with label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product/Service Name *',
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              _buildProductNameField(quoteNotifier),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Qty and Rate in a row with labels
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildQuantityField(quoteNotifier),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate (₹)',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRateField(quoteNotifier),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Discount and Tax in a row with labels
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount (₹)',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildDiscountField(quoteNotifier),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildTaxField(quoteNotifier),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Total display with label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Line Total',
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              _buildTotalDisplay(),
            ],
          ),
        ],
      ),
    );
  }

  /// Product/Service name text field
  Widget _buildProductNameField(QuoteNotifier quoteNotifier) {
    return TextFormField(
      key: ValueKey(
        'productName_${index}_${item.quantity}_${item.rate}_${item.discount}_${item.taxPercent}',
      ),
      initialValue: item.productName,
      decoration: InputDecoration(
        hintText: 'Enter product or service name',
        isDense: true,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      onChanged: (value) {
        quoteNotifier.updateItem(index, 'productName', value);
      },
      textCapitalization: TextCapitalization.words,
    );
  }

  /// Quantity number field
  Widget _buildQuantityField(QuoteNotifier quoteNotifier) {
    return TextFormField(
      key: ValueKey(
        'quantity_${index}_${item.rate}_${item.discount}_${item.taxPercent}',
      ),
      initialValue: item.quantity == 0 ? '' : item.quantity.toString(),
      decoration: InputDecoration(
        hintText: '0',
        isDense: true,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        // Only allow numbers and one decimal point
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      textAlign: TextAlign.center,
      onChanged: (value) {
        final qty = FormatHelper.parseDouble(value);
        quoteNotifier.updateItem(index, 'quantity', qty);
      },
    );
  }

  /// Rate (price per unit) field
  Widget _buildRateField(QuoteNotifier quoteNotifier) {
    return TextFormField(
      key: ValueKey(
        'rate_${index}_${item.quantity}_${item.discount}_${item.taxPercent}',
      ),
      initialValue: item.rate == 0 ? '' : item.rate.toStringAsFixed(2),
      decoration: InputDecoration(
        hintText: '0.00',
        isDense: true,
        prefixText: '₹ ',
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      textAlign: TextAlign.right,
      onChanged: (value) {
        final rate = FormatHelper.parseDouble(value);
        quoteNotifier.updateItem(index, 'rate', rate);
      },
    );
  }

  /// Discount field (optional)
  Widget _buildDiscountField(QuoteNotifier quoteNotifier) {
    return TextFormField(
      key: ValueKey(
        'discount_${index}_${item.quantity}_${item.rate}_${item.taxPercent}',
      ),
      initialValue: item.discount == 0 ? '' : item.discount.toStringAsFixed(2),
      decoration: InputDecoration(
        hintText: '0.00',
        isDense: true,
        prefixText: '₹ ',
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      textAlign: TextAlign.right,
      onChanged: (value) {
        final discount = FormatHelper.parseDouble(value);
        quoteNotifier.updateItem(index, 'discount', discount);
      },
    );
  }

  /// Tax amount field (fixed amount, not percentage)
  Widget _buildTaxField(QuoteNotifier quoteNotifier) {
    return TextFormField(
      key: ValueKey(
        'taxPercent_${index}_${item.quantity}_${item.rate}_${item.discount}',
      ),
      initialValue: item.taxPercent == 0
          ? ''
          : item.taxPercent.toStringAsFixed(2),
      decoration: InputDecoration(
        hintText: '0.00',
        isDense: true,
        prefixText: '₹ ',
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      textAlign: TextAlign.right,
      onChanged: (value) {
        final taxPercent = FormatHelper.parseDouble(value);
        quoteNotifier.updateItem(index, 'taxPercent', taxPercent);
      },
    );
  }

  /// Display calculated total (non-editable)
  Widget _buildTotalDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryLight.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        FormatHelper.formatCurrency(item.itemTotal),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryDark,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}

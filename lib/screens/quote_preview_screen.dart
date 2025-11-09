import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import '../services/pdf_service.dart';

/// This screen shows a professional preview of the quote
/// Like a print-ready invoice that can be sent to clients

class QuotePreviewScreen extends ConsumerWidget {
  const QuotePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Preview'),
        actions: [
          // Edit button to go back
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Edit Quote',
          ),
          // Print button - generates PDF
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              try {
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating PDF...'),
                    duration: Duration(seconds: 1),
                  ),
                );

                // Generate and show print dialog
                await PdfService.generateQuotePdf(quote);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error generating PDF: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            tooltip: 'Print Quote',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // Make it look like a paper document
          margin: const EdgeInsets.all(AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(quote),

              const Divider(height: AppSpacing.xl),

              // Client Info
              _buildClientInfo(quote),

              const SizedBox(height: AppSpacing.xl),

              // Items Table
              _buildItemsTable(quote),

              const SizedBox(height: AppSpacing.lg),

              // Totals
              _buildTotals(quote),

              const SizedBox(height: AppSpacing.xxl),

              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the quote header
  Widget _buildHeader(quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QUOTATION',
              style: AppTextStyles.heading1.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('Quote #${quote.id}', style: AppTextStyles.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Date: ${DateHelper.formatDate(quote.createdDate)}',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  /// Build client information section
  Widget _buildClientInfo(quote) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BILL TO:', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.sm),
          Text(
            quote.clientInfo.name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(quote.clientInfo.address, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.contact_phone,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(quote.clientInfo.reference, style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  /// Build items table
  Widget _buildItemsTable(quote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ITEMS',
          style: AppTextStyles.label.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Make table scrollable horizontally if needed
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 600, maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            'Description',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Qty',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Rate',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            'Discount',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            'Tax',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            'Amount',
                            style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table rows
                  ...quote.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isEven = index % 2 == 0;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isEven ? Colors.white : Colors.grey[50],
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              item.productName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              item.quantity.toString(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              FormatHelper.formatCurrency(item.rate),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 90,
                            child: Text(
                              FormatHelper.formatCurrency(item.discount),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Text(
                              FormatHelper.formatCurrency(item.taxPercent),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              FormatHelper.formatCurrency(item.itemTotal),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryDark,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build totals section
  Widget _buildTotals(quote) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal (before tax)', quote.subtotalBeforeTax),
          const Divider(),
          _buildTotalRow('Total Tax', quote.totalTax),
          const Divider(thickness: 2),
          _buildTotalRow('GRAND TOTAL', quote.grandTotal, isGrandTotal: true),
        ],
      ),
    );
  }

  /// Build a single total row
  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isGrandTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isGrandTotal
                ? AppTextStyles.heading3.copyWith(color: AppTheme.primaryColor)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            FormatHelper.formatCurrency(amount),
            style: isGrandTotal
                ? AppTextStyles.currency.copyWith(
                    fontSize: 20,
                    color: AppTheme.primaryColor,
                  )
                : AppTextStyles.currency.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Build footer with thank you message
  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Thank you for your business!',
          style: AppTextStyles.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Generated by ${AppConstants.appName}',
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

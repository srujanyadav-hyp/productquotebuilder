import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../services/draft_service.dart';
import '../services/pdf_service.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import '../widgets/client_info_section.dart';
import '../widgets/quote_totals_section.dart';
import 'line_items_screen.dart';
import 'drafts_screen.dart';

/// This is the MAIN SCREEN where users create and edit quotes
/// It's like the main page of a form with multiple sections

class QuoteFormScreen extends ConsumerWidget {
  const QuoteFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the quote provider - this rebuilds when quote data changes
    // Think of it like subscribing to notifications
    final quote = ref.watch(quoteNotifierProvider);

    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // View Drafts button
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DraftsScreen()),
              );
            },
            tooltip: 'View Drafts',
          ),
          // Print button - generates PDF and saves draft
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              if (quote.isValid) {
                try {
                  // Save as draft first
                  final draftService = DraftService();
                  await draftService.saveDraft(quote);

                  // Show loading indicator
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Generating PDF...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }

                  // Generate and show print dialog
                  await PdfService.generateQuotePdf(quote);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error generating PDF: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } else {
                // Show specific error message if validation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(quote.validationMessage),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            tooltip: 'Print Quote',
          ),
        ],
      ),

      // Main scrollable body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Client Information
            ClientInfoSection(),

            const SizedBox(height: AppSpacing.lg),

            // Section 2: Line Items - Navigate to dedicated screen
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LineItemsScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text('Line Items', style: AppTextStyles.heading3),
                            ],
                          ),
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
                              '${quote.items.length} item${quote.items.length != 1 ? 's' : ''}',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quote.items.isEmpty
                                ? 'No items added yet'
                                : 'Tap to manage items',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 3: Totals (subtotal, grand total)
            QuoteTotalsSection(),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

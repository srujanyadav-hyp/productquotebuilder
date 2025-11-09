import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';

/// This widget displays and allows editing of client information
/// It's like the "Bill To" section on an invoice

class ClientInfoSection extends ConsumerWidget {
  const ClientInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the quote notifier to call update methods
    final quoteNotifier = ref.read(quoteNotifierProvider.notifier);

    // Get current quote to read client info
    final quote = ref.watch(quoteNotifierProvider);
    final clientInfo = quote.clientInfo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Row(
              children: [
                Icon(Icons.person, color: AppTheme.primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text('Client Information', style: AppTextStyles.heading3),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Client Name field
            // We use TextFormField with initialValue instead of controller
            // This prevents the text selection error when typing
            TextFormField(
              initialValue: clientInfo.name,
              decoration: const InputDecoration(
                labelText: 'Client Name',
                hintText: 'Enter client or company name',
                prefixIcon: Icon(Icons.business),
              ),
              // When user types, update the quote
              onChanged: (value) {
                quoteNotifier.updateClientName(value);
              },
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: AppSpacing.md),

            // Client Address field (multiline)
            TextFormField(
              initialValue: clientInfo.address,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Enter full address',
                prefixIcon: Icon(Icons.location_on),
                alignLabelWithHint: true,
              ),
              onChanged: (value) {
                quoteNotifier.updateClientAddress(value);
              },
              maxLines: 3, // Allow multiple lines for address
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: AppSpacing.md),

            // Reference/Contact field
            TextFormField(
              initialValue: clientInfo.reference,
              decoration: const InputDecoration(
                labelText: 'Reference/Contact',
                hintText: 'Phone, email, or reference number',
                prefixIcon: Icon(Icons.contact_phone),
              ),
              onChanged: (value) {
                quoteNotifier.updateClientReference(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

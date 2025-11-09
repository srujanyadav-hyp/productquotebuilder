import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote.dart';
import '../services/draft_service.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../utils/helpers.dart';
import 'quote_form_screen.dart';

/// Screen to display all saved quote drafts
/// Users can view, load, or delete saved drafts

class DraftsScreen extends ConsumerStatefulWidget {
  const DraftsScreen({super.key});

  @override
  ConsumerState<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends ConsumerState<DraftsScreen> {
  final DraftService _draftService = DraftService();
  List<Quote> _drafts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  /// Load all drafts from storage
  Future<void> _loadDrafts() async {
    setState(() => _isLoading = true);
    final drafts = await _draftService.getAllDrafts();
    setState(() {
      _drafts = drafts;
      _isLoading = false;
    });
  }

  /// Load a draft into the quote form
  Future<void> _loadDraft(Quote draft) async {
    final quoteNotifier = ref.read(quoteNotifierProvider.notifier);

    // Load the draft into the provider
    quoteNotifier.loadQuote(draft);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Draft loaded: ${draft.clientInfo.name}'),
          backgroundColor: AppTheme.accentColor,
        ),
      );

      // Navigate back to form screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const QuoteFormScreen()),
        (route) => false,
      );
    }
  }

  /// Delete a draft
  Future<void> _deleteDraft(Quote draft) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Draft'),
        content: Text(
          'Are you sure you want to delete the draft for "${draft.clientInfo.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _draftService.deleteDraft(draft.id);
      _loadDrafts(); // Refresh list

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft deleted'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Drafts'),
        actions: [
          if (_drafts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Drafts'),
                    content: const Text(
                      'Are you sure you want to delete all drafts?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                        ),
                        child: const Text('Delete All'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await _draftService.clearAllDrafts();
                  _loadDrafts();
                }
              },
              tooltip: 'Clear all drafts',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _drafts.isEmpty
          ? _buildEmptyState()
          : _buildDraftsList(),
    );
  }

  /// Build empty state when no drafts exist
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drafts_outlined, size: 120, color: Colors.grey[300]),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Saved Drafts',
              style: AppTextStyles.heading2.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Save quotes as drafts to access them later',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.add),
              label: const Text('Create New Quote'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build list of drafts
  Widget _buildDraftsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _drafts.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final draft = _drafts[index];
        return _buildDraftCard(draft);
      },
    );
  }

  /// Build individual draft card
  Widget _buildDraftCard(Quote draft) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _loadDraft(draft),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with client name and delete button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draft.clientInfo.name.isEmpty
                              ? 'Unnamed Client'
                              : draft.clientInfo.name,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quote #${draft.id.substring(0, 8)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppTheme.errorColor,
                    ),
                    onPressed: () => _deleteDraft(draft),
                    tooltip: 'Delete draft',
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),

              // Draft details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      Icons.calendar_today,
                      'Created',
                      DateHelper.formatDate(draft.createdDate),
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.list_alt,
                      'Items',
                      '${draft.items.length}',
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.attach_money,
                      'Total',
                      FormatHelper.formatCurrency(draft.grandTotal),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Load button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _loadDraft(draft),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Load Draft'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build detail item (icon + label + value)
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

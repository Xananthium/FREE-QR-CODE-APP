import 'package:flutter/material.dart';
import 'empty_state.dart';

/// Example screen demonstrating all empty state components
/// This file shows developers how to use the empty state UI patterns
class EmptyStateExamplesScreen extends StatelessWidget {
  const EmptyStateExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empty State Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Introduction
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Empty States',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Empty states help users understand what to do when there\'s no content. '
                    'They should be friendly, helpful, and guide users to the next action.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section: Full Empty States
          Text(
            'Full Empty States',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            'No QR Code',
            'When no QR code has been generated yet',
            () => _showEmptyState(
              context,
              EmptyState.noQrCode(
                onCreatePressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigate to home')),
                  );
                },
              ),
            ),
          ),

          _buildExampleCard(
            context,
            'No History',
            'When user has no QR code history',
            () => _showEmptyState(
              context,
              EmptyState.noHistory(
                onCreatePressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create QR code')),
                  );
                },
              ),
            ),
          ),

          _buildExampleCard(
            context,
            'No Scans',
            'When user hasn\'t scanned any codes',
            () => _showEmptyState(
              context,
              EmptyState.noScans(
                onScanPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Start scanning')),
                  );
                },
              ),
            ),
          ),

          _buildExampleCard(
            context,
            'No Favorites',
            'When no favorites have been added',
            () => _showEmptyState(
              context,
              EmptyState.noFavorites(
                onBrowsePressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Browse QR codes')),
                  );
                },
              ),
            ),
          ),

          _buildExampleCard(
            context,
            'No Search Results',
            'When search returns no results',
            () => _showEmptyState(
              context,
              EmptyState.noResults(searchQuery: 'Flutter'),
            ),
          ),

          _buildExampleCard(
            context,
            'Network Error',
            'When there\'s a network connection issue',
            () => _showEmptyState(
              context,
              EmptyState.networkError(
                onRetryPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retrying...')),
                  );
                },
              ),
            ),
          ),

          _buildExampleCard(
            context,
            'Generic Error',
            'When something goes wrong',
            () => _showEmptyState(
              context,
              EmptyState.error(
                errorMessage: 'Unable to load data. Please try again.',
                onRetryPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retrying...')),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // Section: Compact Empty States
          Text(
            'Compact Empty States',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'For smaller areas like cards or sections',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Compact examples in cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: SizedBox(
                    height: 150,
                    child: CompactEmptyState(
                      icon: Icons.qr_code_2_outlined,
                      message: 'No QR code',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: SizedBox(
                    height: 150,
                    child: CompactEmptyState(
                      icon: Icons.history_outlined,
                      message: 'No history',
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Card(
                  child: SizedBox(
                    height: 150,
                    child: CompactEmptyState(
                      icon: Icons.search_off_outlined,
                      message: 'No results found',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: SizedBox(
                    height: 150,
                    child: CompactEmptyState(
                      icon: Icons.star_border_outlined,
                      message: 'No favorites yet',
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // Section: Custom Empty State
          Text(
            'Custom Empty State',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            'Custom Configuration',
            'Build your own with custom icon, text, and actions',
            () => _showEmptyState(
              context,
              EmptyState(
                icon: Icons.category_outlined,
                title: 'No Categories',
                message: 'Create your first category to organize your QR codes better',
                actionLabel: 'Add Category',
                onActionPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add category')),
                  );
                },
                iconSize: 140,
              ),
            ),
          ),

          _buildExampleCard(
            context,
            'Without Animation',
            'Empty state with animation disabled',
            () => _showEmptyState(
              context,
              EmptyState(
                icon: Icons.folder_outlined,
                title: 'Empty Folder',
                message: 'This folder is empty',
                animate: false,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Best Practices
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Best Practices',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Use clear, friendly language\n'
                    '• Explain why the state is empty\n'
                    '• Guide users to the next action\n'
                    '• Keep messages concise\n'
                    '• Use appropriate icons\n'
                    '• Include action buttons when helpful\n'
                    '• Consider compact variants for small spaces',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Build an example card with title and action
  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show empty state in a full-screen dialog
  void _showEmptyState(BuildContext context, Widget emptyState) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Preview'),
          ),
          body: emptyState,
        ),
      ),
    );
  }
}

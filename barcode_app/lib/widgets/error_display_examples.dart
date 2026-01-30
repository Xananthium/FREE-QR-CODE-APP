import 'package:flutter/material.dart';
import 'error_display.dart';

/// Example screen demonstrating all error display components
/// This file shows developers how to use the error handling UI
class ErrorDisplayExamplesScreen extends StatefulWidget {
  const ErrorDisplayExamplesScreen({super.key});

  @override
  State<ErrorDisplayExamplesScreen> createState() =>
      _ErrorDisplayExamplesScreenState();
}

class _ErrorDisplayExamplesScreenState
    extends State<ErrorDisplayExamplesScreen> {
  bool _showBanner = false;
  bool _isRetrying = false;

  void _handleRetry() {
    setState(() => _isRetrying = true);
    // Simulate retry operation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isRetrying = false);
        ErrorDisplay.showSuccess(context, 'Retry successful!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Display Examples'),
      ),
      body: Column(
        children: [
          // Error Banner (conditional)
          if (_showBanner)
            ErrorBanner(
              message: 'Connection lost. Some features may be unavailable.',
              onRetry: _handleRetry,
              onDismiss: () => setState(() => _showBanner = false),
            ),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Section: Snackbars
                Text(
                  'Snackbars',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ErrorDisplay.showError(
                          context,
                          'Failed to scan barcode',
                        );
                      },
                      child: const Text('Show Error'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ErrorDisplay.showError(
                          context,
                          'Network error occurred',
                          action: ErrorAction(
                            label: 'Retry',
                            onPressed: _handleRetry,
                          ),
                        );
                      },
                      child: const Text('Error with Retry'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ErrorDisplay.showWarning(
                          context,
                          'Low storage space',
                        );
                      },
                      child: const Text('Show Warning'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ErrorDisplay.showSuccess(
                          context,
                          'QR code saved successfully!',
                        );
                      },
                      child: const Text('Show Success'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ErrorDisplay.showInfo(
                          context,
                          'Tap the QR code to view details',
                        );
                      },
                      child: const Text('Show Info'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // Section: Error Card
                Text(
                  'Error Card',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ErrorCard(
                  message: 'Unable to connect to the server. Please try again.',
                  onRetry: _handleRetry,
                  onDismiss: () {
                    ErrorDisplay.showInfo(context, 'Error dismissed');
                  },
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // Section: Error Banner
                Text(
                  'Error Banner',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _showBanner = !_showBanner),
                  child: Text(_showBanner ? 'Hide Banner' : 'Show Banner'),
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // Section: Full-Screen Error States
                Text(
                  'Full-Screen Error States',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(title: const Text('Error State')),
                              body: ErrorStateWidget(
                                title: 'Failed to Load',
                                message:
                                    'We couldn\'t load your data. Please try again.',
                                onRetry: () {
                                  Navigator.pop(context);
                                  ErrorDisplay.showSuccess(
                                    context,
                                    'Loaded successfully!',
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Generic Error'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                  title: const Text('Network Error')),
                              body: NetworkErrorWidget(
                                onRetry: () {
                                  Navigator.pop(context);
                                  ErrorDisplay.showSuccess(
                                    context,
                                    'Connected!',
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Network Error'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar:
                                  AppBar(title: const Text('Loading Error')),
                              body: LoadingErrorWidget(
                                message:
                                    'Failed to load QR codes from the server.',
                                onRetry: () {
                                  Navigator.pop(context);
                                  ErrorDisplay.showSuccess(
                                    context,
                                    'Loaded!',
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Loading Error'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // Section: Retry Button
                Text(
                  'Retry Button',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                RetryButton(
                  onPressed: _handleRetry,
                  isLoading: _isRetrying,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

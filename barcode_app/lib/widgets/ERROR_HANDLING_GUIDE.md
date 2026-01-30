# Error Handling UI Guide

This guide explains how to use the error handling UI components in the barcode scanner app.

## Overview

The error handling system provides consistent, beautiful error displays throughout the app using Material Design 3 principles. All components automatically support light/dark themes and include accessibility features.

## Components

### 1. ErrorDisplay (Static Methods)

Utility class for showing snackbars. Use these for temporary notifications.

#### Show Error Snackbar
```dart
// Simple error
ErrorDisplay.showError(context, 'Failed to scan barcode');

// Error with retry action
ErrorDisplay.showError(
  context, 
  'Network error',
  action: ErrorAction(
    label: 'Retry',
    onPressed: () => _retryOperation(),
  ),
);

// Custom duration
ErrorDisplay.showError(
  context, 
  'Operation failed',
  duration: Duration(seconds: 6),
);
```

#### Show Warning Snackbar
```dart
ErrorDisplay.showWarning(context, 'Low storage space');
```

#### Show Success Snackbar
```dart
ErrorDisplay.showSuccess(context, 'QR code saved successfully!');
```

#### Show Info Snackbar
```dart
ErrorDisplay.showInfo(context, 'Tap to view details');
```

### 2. ErrorCard

Inline error display for use within scrollable content.

```dart
ErrorCard(
  message: 'Unable to load QR codes from the server.',
  onRetry: () => _loadQRCodes(),
  onDismiss: () => setState(() => _showError = false),
)
```

**Properties:**
- `message` (required): Error message to display
- `onRetry`: Optional callback for retry button
- `onDismiss`: Optional callback for dismiss button

### 3. ErrorBanner

Persistent error display at the top of screens.

```dart
if (_hasError)
  ErrorBanner(
    message: 'Connection lost. Some features may be unavailable.',
    onRetry: () => _reconnect(),
    onDismiss: () => setState(() => _hasError = false),
  )
```

**Use cases:**
- Network connectivity issues
- API errors that affect the whole screen
- Persistent warnings

### 4. ErrorStateWidget

Full-screen error state with icon and retry button.

```dart
ErrorStateWidget(
  title: 'Failed to Load',
  message: 'We couldn\'t load your data. Please try again.',
  icon: Icons.error_outline, // Optional, defaults to error_outline
  onRetry: () => _loadData(),
  retryLabel: 'Try Again', // Optional, defaults to 'Try Again'
)
```

**Use cases:**
- Empty list states with errors
- Failed data loading
- Replace entire screen content on error

### 5. NetworkErrorWidget

Specialized error widget for network issues.

```dart
if (_isOffline)
  NetworkErrorWidget(
    onRetry: () => _reconnect(),
  )
```

### 6. LoadingErrorWidget

Specialized error widget for loading failures.

```dart
LoadingErrorWidget(
  message: 'Failed to load QR codes from the server.',
  onRetry: () => _loadData(),
)
```

### 7. RetryButton

Standalone retry button with loading state.

```dart
RetryButton(
  onPressed: () => _retry(),
  label: 'Try Again', // Optional
  isLoading: _isRetrying,
)
```

## Common Patterns

### Pattern 1: Form Validation Errors

Use inline `InputField` error messages for validation:

```dart
InputField(
  label: 'Email',
  errorText: _emailError, // null when valid
  onChanged: (value) => _validateEmail(value),
)
```

### Pattern 2: Network Operation Errors

```dart
try {
  await _scanBarcode();
  ErrorDisplay.showSuccess(context, 'Scanned successfully!');
} catch (e) {
  ErrorDisplay.showError(
    context,
    'Scan failed: ${e.message}',
    action: ErrorAction(
      label: 'Retry',
      onPressed: () => _scanBarcode(),
    ),
  );
}
```

### Pattern 3: List Loading Errors

```dart
FutureBuilder<List<QRCode>>(
  future: _loadQRCodes(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return LoadingErrorWidget(
        message: 'Failed to load your QR codes.',
        onRetry: () => setState(() {}), // Rebuild to retry
      );
    }
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }
    return ListView(children: ...);
  },
)
```

### Pattern 4: Persistent Error Banner

```dart
Column(
  children: [
    if (_networkError)
      ErrorBanner(
        message: 'No internet connection',
        onRetry: () => _checkConnection(),
        onDismiss: () => setState(() => _networkError = false),
      ),
    Expanded(
      child: YourContent(),
    ),
  ],
)
```

### Pattern 5: Conditional Error Card

```dart
ListView(
  children: [
    if (_hasError)
      Padding(
        padding: const EdgeInsets.all(16),
        child: ErrorCard(
          message: _errorMessage,
          onRetry: () => _retry(),
          onDismiss: () => setState(() => _hasError = false),
        ),
      ),
    ...regularContent,
  ],
)
```

## Best Practices

### 1. Choose the Right Component

- **Snackbar** - Temporary, non-blocking feedback
- **ErrorCard** - Inline errors in scrollable content
- **ErrorBanner** - Persistent errors affecting the whole screen
- **ErrorStateWidget** - Replace entire content area
- **InputField.errorText** - Form validation

### 2. Provide Retry Options

Always provide retry options for recoverable errors:

```dart
// Good
ErrorDisplay.showError(
  context,
  'Failed to save',
  action: ErrorAction(label: 'Retry', onPressed: _save),
);

// Less helpful
ErrorDisplay.showError(context, 'Failed to save');
```

### 3. Clear Error Messages

Be specific about what went wrong and what the user should do:

```dart
// Good
'Network connection lost. Check your WiFi and try again.'

// Vague
'An error occurred.'
```

### 4. Handle Loading States

Show loading indicators during retry operations:

```dart
bool _isRetrying = false;

void _retry() async {
  setState(() => _isRetrying = true);
  try {
    await _operation();
    ErrorDisplay.showSuccess(context, 'Success!');
  } catch (e) {
    ErrorDisplay.showError(context, e.message);
  } finally {
    setState(() => _isRetrying = false);
  }
}
```

### 5. Dismiss Snackbars Before Showing New Ones

The `ErrorDisplay` class automatically clears previous snackbars, but be mindful of showing too many in rapid succession.

### 6. Use Semantic Labels

All error components include proper semantics for screen readers. No additional work needed.

## Color Scheme

The error handling components use the following colors from `AppColors`:

- **Error**: `errorLight` / `errorDark`
- **Warning**: `warningOrange`
- **Success**: `successGreen`
- **Info**: `primaryLight` / `primaryDark`

All components automatically adapt to light/dark theme.

## Animations

All error components include smooth animations:
- Snackbars slide in from bottom
- Error cards fade in/out
- Banners slide down from top
- Full-screen states fade in

## Accessibility

All components include:
- Proper semantic labels
- Screen reader support
- Sufficient color contrast
- Touch target sizes ≥48px
- Keyboard navigation support

## Testing

To test error states in development:

1. Run the examples screen:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ErrorDisplayExamplesScreen(),
  ),
);
```

2. Or manually test each component:
```dart
// Test error snackbar
ElevatedButton(
  onPressed: () => ErrorDisplay.showError(context, 'Test error'),
  child: Text('Test Error'),
)
```

## Migration from Old Error Handling

If you have existing error displays:

### Before
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Error occurred')),
);
```

### After
```dart
ErrorDisplay.showError(context, 'Error occurred');
```

### Before
```dart
Text(
  'Error: $message',
  style: TextStyle(color: Colors.red),
)
```

### After
```dart
ErrorCard(message: message)
```

## See Also

- `lib/widgets/input_field.dart` - Form field with inline error display
- `lib/screens/error_screen.dart` - Full-screen error page for routing errors
- `lib/core/constants/app_colors.dart` - Color definitions

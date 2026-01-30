import 'dart:async';

/// Utility functions for managing loading states and preventing UI flicker
/// 
/// These helpers ensure smooth loading experiences by:
/// - Enforcing minimum display durations
/// - Debouncing rapid operations
/// - Wrapping async operations cleanly
class LoadingHelpers {
  LoadingHelpers._(); // Private constructor - static class only

  /// Ensures an operation takes at least the specified minimum duration
  /// 
  /// This prevents loading state flicker when operations complete too quickly.
  /// If the operation completes in less than [minDuration], it will wait until
  /// the minimum duration has elapsed before completing.
  /// 
  /// Example:
  /// ```dart
  /// await LoadingHelpers.withMinimumDuration(
  ///   minDuration: Duration(milliseconds: 200),
  ///   operation: () async {
  ///     // Fast operation that might complete in <200ms
  ///     await fetchData();
  ///   },
  /// );
  /// ```
  static Future<T> withMinimumDuration<T>({
    required Duration minDuration,
    required Future<T> Function() operation,
  }) async {
    final startTime = DateTime.now();
    
    // Execute the operation
    final result = await operation();
    
    // Calculate remaining time
    final elapsed = DateTime.now().difference(startTime);
    final remaining = minDuration - elapsed;
    
    // Wait if we haven't reached minimum duration
    if (remaining.inMilliseconds > 0) {
      await Future.delayed(remaining);
    }
    
    return result;
  }

  /// Creates a debounced version of a function
  /// 
  /// Returns a function that delays invoking [callback] until after [duration]
  /// has elapsed since the last time the debounced function was invoked.
  /// 
  /// Useful for preventing excessive operations during rapid user input,
  /// such as search-as-you-type or real-time validation.
  /// 
  /// Example:
  /// ```dart
  /// final debouncedSearch = LoadingHelpers.debounce(
  ///   Duration(milliseconds: 500),
  ///   (String query) {
  ///     performSearch(query);
  ///   },
  /// );
  /// 
  /// // User types rapidly - only last call after 500ms pause will execute
  /// debouncedSearch('a');
  /// debouncedSearch('ab');
  /// debouncedSearch('abc'); // Only this will execute after 500ms
  /// ```
  static void Function(T) debounce<T>(
    Duration duration,
    void Function(T) callback,
  ) {
    Timer? timer;
    
    return (T value) {
      timer?.cancel();
      timer = Timer(duration, () {
        callback(value);
      });
    };
  }

  /// Creates a throttled version of a function
  /// 
  /// Returns a function that only invokes [callback] at most once per [duration].
  /// Unlike debounce, throttle ensures the callback is called periodically
  /// during continuous invocations, not just at the end.
  /// 
  /// Useful for rate-limiting frequent events like scroll handlers or
  /// resize listeners.
  /// 
  /// Example:
  /// ```dart
  /// final throttledScroll = LoadingHelpers.throttle(
  ///   Duration(milliseconds: 100),
  ///   () {
  ///     updateScrollPosition();
  ///   },
  /// );
  /// 
  /// // Called many times during scroll, but executes max once per 100ms
  /// scrollController.addListener(throttledScroll);
  /// ```
  static void Function() throttle(
    Duration duration,
    void Function() callback,
  ) {
    DateTime? lastExecution;
    
    return () {
      final now = DateTime.now();
      
      if (lastExecution == null ||
          now.difference(lastExecution!) >= duration) {
        lastExecution = now;
        callback();
      }
    };
  }

  /// Executes an async operation with automatic retry on failure
  /// 
  /// Attempts the operation up to [maxAttempts] times, waiting [retryDelay]
  /// between attempts. Returns the result on success or rethrows the last
  /// error after all attempts fail.
  /// 
  /// Example:
  /// ```dart
  /// final data = await LoadingHelpers.withRetry(
  ///   operation: () => networkCall(),
  ///   maxAttempts: 3,
  ///   retryDelay: Duration(seconds: 1),
  /// );
  /// ```
  static Future<T> withRetry<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) async {
    assert(maxAttempts > 0, 'maxAttempts must be greater than 0');
    
    Object? lastError;
    
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastError = e;
        
        // Don't delay after the last attempt
        if (attempt < maxAttempts) {
          await Future.delayed(retryDelay);
        }
      }
    }
    
    // All attempts failed - rethrow last error
    throw lastError!;
  }
}

/// Helper class for managing debounced timers
/// 
/// Simplifies creating disposable debounced operations.
/// Remember to call [dispose] when done to cancel pending timers.
/// 
/// Example in a StatefulWidget:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> {
///   final _debouncer = DebouncedOperation();
///   
///   void _onTextChanged(String value) {
///     _debouncer.run(
///       Duration(milliseconds: 500),
///       () {
///         validateInput(value);
///       },
///     );
///   }
///   
///   @override
///   void dispose() {
///     _debouncer.dispose();
///     super.dispose();
///   }
/// }
/// ```
class DebouncedOperation {
  Timer? _timer;

  /// Execute [callback] after [duration] has elapsed without another call
  void run(Duration duration, void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  /// Cancel any pending operation
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Dispose of this debouncer and cancel any pending operation
  void dispose() {
    cancel();
  }

  /// Whether there is a pending operation
  bool get isPending => _timer != null && _timer!.isActive;
}

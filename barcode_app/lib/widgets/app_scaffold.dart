import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Common app scaffold with standardized app bar
/// 
/// Provides a consistent layout structure across the app with a
/// beautiful, customizable app bar and common UI patterns.
class AppScaffold extends StatelessWidget {
  /// The primary content of the scaffold
  final Widget body;

  /// Title to display in the app bar
  final String? title;

  /// Custom title widget (overrides [title])
  final Widget? titleWidget;

  /// Leading widget (usually back button or menu)
  final Widget? leading;

  /// Actions to display in app bar
  final List<Widget>? actions;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// FAB location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Whether to show back button
  final bool showBackButton;

  /// Whether to center the title
  final bool centerTitle;

  /// Background color override
  final Color? backgroundColor;

  /// App bar background color override
  final Color? appBarBackgroundColor;

  /// Whether to add safe area padding
  final bool useSafeArea;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Whether to resize to avoid bottom inset (keyboard)
  final bool resizeToAvoidBottomInset;

  /// Custom drawer
  final Widget? drawer;

  /// End drawer
  final Widget? endDrawer;

  /// System UI overlay style (status bar style)
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether to show app bar
  final bool showAppBar;

  /// App bar elevation
  final double appBarElevation;

  /// Custom app bar bottom widget
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showBackButton = false,
    this.centerTitle = true,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.useSafeArea = true,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.drawer,
    this.endDrawer,
    this.systemOverlayStyle,
    this.showAppBar = true,
    this.appBarElevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine system UI overlay style based on theme
    final defaultOverlayStyle = theme.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;

    final effectiveOverlayStyle = systemOverlayStyle ?? defaultOverlayStyle;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: effectiveOverlayStyle,
      child: Scaffold(
        backgroundColor: backgroundColor ?? colorScheme.surface,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        drawer: drawer,
        endDrawer: endDrawer,
        appBar: showAppBar
            ? AppBar(
                title: titleWidget ??
                    (title != null
                        ? Text(
                            title!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          )
                        : null),
                centerTitle: centerTitle,
                elevation: appBarElevation,
                scrolledUnderElevation: 2,
                backgroundColor:
                    appBarBackgroundColor ?? colorScheme.surface,
                surfaceTintColor: colorScheme.surfaceTint,
                leading: leading ??
                    (showBackButton
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Back',
                          )
                        : null),
                actions: actions,
                bottom: bottom,
                systemOverlayStyle: effectiveOverlayStyle,
              )
            : null,
        body: useSafeArea ? SafeArea(child: body) : body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}

/// App scaffold variant with search functionality
class SearchableAppScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onSearchClosed;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const SearchableAppScaffold({
    super.key,
    required this.body,
    this.title,
    this.searchHint = 'Search...',
    required this.onSearchChanged,
    this.onSearchClosed,
    this.actions,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  State<SearchableAppScaffold> createState() => _SearchableAppScaffoldState();
}

class _SearchableAppScaffoldState extends State<SearchableAppScaffold> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    widget.onSearchChanged('');
    widget.onSearchClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      backgroundColor: widget.backgroundColor,
      titleWidget: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              style: theme.textTheme.titleMedium,
              onChanged: widget.onSearchChanged,
            )
          : Text(
              widget.title ?? '',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: _isSearching
          ? [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _stopSearch,
                tooltip: 'Close search',
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _startSearch,
                tooltip: 'Search',
              ),
              ...?widget.actions,
            ],
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}

/// App scaffold variant with bottom sheet support
class AppScaffoldWithBottomSheet extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget bottomSheet;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const AppScaffoldWithBottomSheet({
    super.key,
    required this.body,
    this.title,
    required this.bottomSheet,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
        centerTitle: true,
        actions: actions,
      ),
      body: SafeArea(child: body),
      bottomSheet: bottomSheet,
    );
  }
}

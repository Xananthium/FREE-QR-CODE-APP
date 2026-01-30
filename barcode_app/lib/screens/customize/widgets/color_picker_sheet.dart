import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Color Picker Bottom Sheet
///
/// A beautiful bottom sheet for selecting colors with:
/// - Primary and secondary color selection tabs
/// - Preset color options for quick selection
/// - Custom color picker with Material/Block picker
/// - Apply button to confirm selection
class ColorPickerSheet extends StatefulWidget {
  final Color initialPrimaryColor;
  final Color initialSecondaryColor;
  final Function(Color primary, Color secondary) onColorsSelected;

  const ColorPickerSheet({
    super.key,
    required this.initialPrimaryColor,
    required this.initialSecondaryColor,
    required this.onColorsSelected,
  });

  @override
  State<ColorPickerSheet> createState() => _ColorPickerSheetState();

  /// Show the color picker sheet
  static Future<void> show({
    required BuildContext context,
    required Color initialPrimaryColor,
    required Color initialSecondaryColor,
    required Function(Color primary, Color secondary) onColorsSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ColorPickerSheet(
        initialPrimaryColor: initialPrimaryColor,
        initialSecondaryColor: initialSecondaryColor,
        onColorsSelected: onColorsSelected,
      ),
    );
  }
}

class _ColorPickerSheetState extends State<ColorPickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color _currentPrimaryColor;
  late Color _currentSecondaryColor;
  bool _isPrimaryColorMode = true;

  // Preset color palette
  static const List<Color> _presetColors = [
    // Vibrant colors
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF2196F3), // Blue
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFFC107), // Amber
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
    Color(0xFFF44336), // Red
    // Neutral colors
    Color(0xFF9E9E9E), // Grey
    Color(0xFF607D8B), // Blue Grey
    Color(0xFF795548), // Brown
    Color(0xFF000000), // Black
    Color(0xFFFFFFFF), // White
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentPrimaryColor = widget.initialPrimaryColor;
    _currentSecondaryColor = widget.initialSecondaryColor;
    
    _tabController.addListener(() {
      setState(() {
        _isPrimaryColorMode = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color get _activeColor =>
      _isPrimaryColorMode ? _currentPrimaryColor : _currentSecondaryColor;

  void _updateActiveColor(Color color) {
    setState(() {
      if (_isPrimaryColorMode) {
        _currentPrimaryColor = color;
      } else {
        _currentSecondaryColor = color;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header with tabs
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Colors',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _tabController,
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                      indicatorColor: theme.colorScheme.primary,
                      tabs: const [
                        Tab(text: 'Primary Color'),
                        Tab(text: 'Secondary Color'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Color preview
              _buildColorPreview(theme),

              const SizedBox(height: 16),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildColorPickerContent(scrollController),
                    _buildColorPickerContent(scrollController),
                  ],
                ),
              ),

              // Apply button
              _buildApplyButton(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorPreview(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildColorPreviewItem(
              'Primary',
              _currentPrimaryColor,
              _isPrimaryColorMode,
              theme,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildColorPreviewItem(
              'Secondary',
              _currentSecondaryColor,
              !_isPrimaryColorMode,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreviewItem(
    String label,
    Color color,
    bool isActive,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? theme.colorScheme.primary : null,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: isActive ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildColorPickerContent(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preset colors section
          Text(
            'Preset Colors',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildPresetColors(),
          const SizedBox(height: 24),

          // Custom color picker section
          Text(
            'Custom Color',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildCustomColorPicker(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPresetColors() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _presetColors.map((color) {
        final isSelected = _activeColor.toARGB32() == color.toARGB32();
        return GestureDetector(
          onTap: () => _updateActiveColor(color),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: _getContrastColor(color),
                    size: 24,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomColorPicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: BlockPicker(
        pickerColor: _activeColor,
        onColorChanged: _updateActiveColor,
        availableColors: const [
          // Extended color palette for block picker
          Colors.red,
          Colors.pink,
          Colors.purple,
          Colors.deepPurple,
          Colors.indigo,
          Colors.blue,
          Colors.lightBlue,
          Colors.cyan,
          Colors.teal,
          Colors.green,
          Colors.lightGreen,
          Colors.lime,
          Colors.yellow,
          Colors.amber,
          Colors.orange,
          Colors.deepOrange,
          Colors.brown,
          Colors.grey,
          Colors.blueGrey,
          Colors.black,
          Colors.white,
        ],
      ),
    );
  }

  Widget _buildApplyButton(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.onColorsSelected(
                _currentPrimaryColor,
                _currentSecondaryColor,
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Apply Colors',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Get contrasting color (black or white) for better visibility
  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

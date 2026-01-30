import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../borders/border_registry.dart' as registry;

/// Border Gallery Widget
///
/// A beautiful horizontal scrolling gallery for selecting QR code borders.
/// Features:
/// - 2-row horizontal grid layout
/// - Smooth scrolling with lazy loading
/// - Animated selection states with check marks
/// - Material 3 design with haptic feedback
/// - Performance optimized with RepaintBoundary
/// - Full accessibility support
class BorderGallery extends StatefulWidget {
  /// Currently selected border type
  final registry.BorderType selectedBorderType;

  /// Primary color for border previews
  final Color primaryColor;

  /// Secondary color for gradient/dual-tone border previews
  final Color? secondaryColor;

  /// Callback when a border is selected
  final ValueChanged<registry.BorderType> onBorderSelected;

  /// Height of the gallery (defaults to 240 for 2 rows of 100px + spacing)
  final double height;

  const BorderGallery({
    super.key,
    required this.selectedBorderType,
    required this.primaryColor,
    required this.onBorderSelected,
    this.secondaryColor,
    this.height = 240.0,
  });

  @override
  State<BorderGallery> createState() => _BorderGalleryState();
}

class _BorderGalleryState extends State<BorderGallery> {
  late registry.BorderType _selectedBorderType;

  @override
  void initState() {
    super.initState();
    _selectedBorderType = widget.selectedBorderType;
  }

  @override
  void didUpdateWidget(BorderGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBorderType != widget.selectedBorderType) {
      setState(() {
        _selectedBorderType = widget.selectedBorderType;
      });
    }
  }

  void _selectBorder(registry.BorderType type) {
    if (_selectedBorderType != type) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedBorderType = type;
      });
      widget.onBorderSelected(type);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderTypes = registry.BorderRegistry.allBorderTypes;

    return SizedBox(
      height: widget.height,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: borderTypes.length,
        itemBuilder: (context, index) {
          final borderType = borderTypes[index];
          final isSelected = borderType == _selectedBorderType;

          return _BorderThumbnailCard(
            borderType: borderType,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            isSelected: isSelected,
            onTap: () => _selectBorder(borderType),
          );
        },
      ),
    );
  }
}

/// Individual border thumbnail card
class _BorderThumbnailCard extends StatelessWidget {
  final registry.BorderType borderType;
  final Color primaryColor;
  final Color? secondaryColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _BorderThumbnailCard({
    required this.borderType,
    required this.primaryColor,
    required this.isSelected,
    required this.onTap,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = registry.BorderRegistry.getBorder(
      borderType,
      color: primaryColor,
      secondaryColor: secondaryColor,
    );

    return Semantics(
      label: border.name,
      hint: border.description,
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.dividerColor.withValues(alpha: 0.3),
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                // Border thumbnail
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RepaintBoundary(
                      child: border.buildThumbnail(const Size(80, 80)),
                    ),
                  ),
                ),

                // Selected check mark
                if (isSelected)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.elasticOut,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

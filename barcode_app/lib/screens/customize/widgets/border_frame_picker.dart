import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/border_frame.dart';
import '../../../providers/qr_provider.dart';
import '../../../core/utils/responsive.dart';

/// Border Frame Picker - Gallery for selecting decorative PNG frames
class BorderFramePicker extends StatefulWidget {
  const BorderFramePicker({super.key});

  @override
  State<BorderFramePicker> createState() => _BorderFramePickerState();
}

class _BorderFramePickerState extends State<BorderFramePicker> {
  String _selectedCategory = 'Cats'; // Cats first!

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final qrProvider = context.watch<QRProvider>();
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category tabs
        _buildCategoryTabs(theme, colorScheme, responsive),
        const SizedBox(height: 16),

        // Frame grid
        _buildFrameGrid(theme, colorScheme, qrProvider, responsive),
      ],
    );
  }

  Widget _buildCategoryTabs(ThemeData theme, ColorScheme colorScheme, Responsive responsive) {
    final categories = ['Cats', 'Punk Rock', 'Cyberpunk', 'Hard/Edgy', 'Creatures', 'Kawaii'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                }
              },
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceVariant,
              labelStyle: TextStyle(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFrameGrid(ThemeData theme, ColorScheme colorScheme, QRProvider qrProvider, Responsive responsive) {
    final frames = BorderFrames.byCategory(_selectedCategory);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.value(
          phone: 3,
          tablet: 4,
          desktop: 5,
        ).toInt(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: frames.length + 1, // +1 for "None" option
      itemBuilder: (context, index) {
        if (index == 0) {
          // "None" option
          return _buildFrameCard(
            theme: theme,
            colorScheme: colorScheme,
            frame: null,
            isSelected: qrProvider.borderFrame == null,
            onTap: () => qrProvider.removeBorderFrame(),
          );
        }

        final frame = frames[index - 1];
        return _buildFrameCard(
          theme: theme,
          colorScheme: colorScheme,
          frame: frame,
          isSelected: qrProvider.borderFrame?.id == frame.id,
          onTap: () => qrProvider.updateBorderFrame(frame),
        );
      },
    );
  }

  Widget _buildFrameCard({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required BorderFrame? frame,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: frame == null
              ? _buildNoneOption(theme, colorScheme, isSelected)
              : _buildFramePreview(frame, theme, colorScheme, isSelected),
        ),
      ),
    );
  }

  Widget _buildNoneOption(ThemeData theme, ColorScheme colorScheme, bool isSelected) {
    return Container(
      color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            'None',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFramePreview(BorderFrame frame, ThemeData theme, ColorScheme colorScheme, bool isSelected) {
    return Stack(
      children: [
        // Frame image
        Positioned.fill(
          child: Image.asset(
            frame.assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: colorScheme.errorContainer,
                child: Icon(
                  Icons.broken_image,
                  color: colorScheme.onErrorContainer,
                ),
              );
            },
          ),
        ),

        // Selection indicator
        if (isSelected)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.check,
                color: colorScheme.onPrimary,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/navigation/app_router.dart';
import '../../core/animations/widget_animations.dart';
import '../../core/animations/animation_constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/services/qr_history_service.dart';
import '../../models/qr_history_item.dart';
import '../../providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/brand_constants.dart';

/// Museum Gallery Home Screen - Digital Eclipse Collection
/// NOW WITH SWIPE CAROUSEL!
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _themeToggleController;
  final PageController _pageController = PageController();
  final QRHistoryService _historyService = QRHistoryService();
  int _currentPage = 0;
  List<QRHistoryItem> _historyItems = [];

  final List<QRTypeData> _qrTypes = [
    QRTypeData(
      icon: Icons.link_rounded,
      title: 'URL/Website',
      subtitle: 'Direct links',
      primaryColor: const Color(0xFF556270),
      secondaryColor: const Color(0xFF8B6F47),
      route: 'url',
    ),
    QRTypeData(
      icon: Icons.wifi_rounded,
      title: 'WiFi Network',
      subtitle: 'Auto-connect',
      primaryColor: const Color(0xFF2C5F8D),
      secondaryColor: const Color(0xFF556270),
      route: 'wifi',
    ),
    QRTypeData(
      icon: Icons.email_rounded,
      title: 'Email',
      subtitle: 'Pre-filled email',
      primaryColor: const Color(0xFF6B4C59),
      secondaryColor: const Color(0xFF8B6F47),
      route: 'email',
    ),
    QRTypeData(
      icon: Icons.phone_rounded,
      title: 'Phone',
      subtitle: 'Direct dial',
      primaryColor: const Color(0xFF4A5D6C),
      secondaryColor: const Color(0xFF2C5F8D),
      route: 'phone',
    ),
    QRTypeData(
      icon: Icons.message_rounded,
      title: 'SMS',
      subtitle: 'Pre-filled text',
      primaryColor: const Color(0xFF3E6B7F),
      secondaryColor: const Color(0xFF4A5D6C),
      route: 'sms',
    ),
    QRTypeData(
      icon: Icons.contact_page_rounded,
      title: 'Contact/vCard',
      subtitle: 'Business cards',
      primaryColor: const Color(0xFF8B6F47),
      secondaryColor: const Color(0xFFA67C52),
      route: 'contact',
    ),
    QRTypeData(
      icon: Icons.location_on_rounded,
      title: 'Location',
      subtitle: 'GPS coordinates',
      primaryColor: const Color(0xFF5A7A6B),
      secondaryColor: const Color(0xFF6B8E7D),
      route: 'location',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _themeToggleController = AnimationController(
      duration: AnimationDurations.normal,
      vsync: this,
    );
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      final wrappedPage = page % _qrTypes.length;
      if (wrappedPage != _currentPage) {
        setState(() => _currentPage = wrappedPage);
      }
    });
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload history when coming back to this screen
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _historyService.getHistory();
    if (mounted) {
      setState(() {
        _historyItems = history;
      });
    }
  }

  @override
  void dispose() {
    _themeToggleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleTheme(ThemeProvider provider) {
    provider.toggleTheme();
    if (provider.isDarkMode) {
      _themeToggleController.forward();
    } else {
      _themeToggleController.reverse();
    }
  }

  Future<void> _launchWebsite() async {
    final uri = Uri.parse(BrandConstants.websiteUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToGenerator(String route) {
    switch (route) {
      case 'url':
        context.goToUrlGenerator();
        break;
      case 'wifi':
        context.goToWifiGenerator();
        break;
      case 'email':
        context.goToEmailGenerator();
        break;
      case 'phone':
        context.goToPhoneGenerator();
        break;
      case 'sms':
        context.goToSmsGenerator();
        break;
      case 'contact':
        context.goToContactGenerator();
        break;
      case 'location':
        context.goToLocationGenerator();
        break;
    }
  }

  void _showQRTypeMenu(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Select QR Type',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            // QR type list
            ..._qrTypes.map((qrType) {
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [qrType.primaryColor, qrType.secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(qrType.icon, color: Colors.white, size: 24),
                ),
                title: Text(
                  qrType.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(qrType.subtitle),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToGenerator(qrType.route);
                },
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final responsive = context.responsive;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background eclipse watermarks
          if (isDark) ...[
            Positioned(
              top: -100,
              right: -100,
              child: Opacity(
                opacity: 0.02,
                child: CustomPaint(
                  size: const Size(400, 400),
                  painter: _EclipseBackgroundPainter(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Opacity(
                opacity: 0.015,
                child: CustomPaint(
                  size: const Size(500, 500),
                  painter: _EclipseBackgroundPainter(
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar with hamburger menu, info button, and theme toggle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.spacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hamburger menu for QR type selection
                      IconButton(
                        icon: const Icon(Icons.menu_rounded, size: 24),
                        tooltip: 'Select QR Type',
                        onPressed: () => _showQRTypeMenu(context),
                      ),
                      // Right side buttons
                      Row(
                        children: [
                          // Info button
                          IconButton(
                            icon: const Icon(Icons.info_outline_rounded, size: 24),
                            tooltip: 'About',
                            onPressed: () => context.goToAbout(),
                          ),
                          SizedBox(width: responsive.spacing * 0.5),
                          // Theme toggle
                          IconButton(
                            icon: RotationTransition(
                              turns: Tween<double>(begin: 0.0, end: 0.5)
                                  .animate(_themeToggleController),
                              child: Icon(
                                themeProvider.isDarkMode
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                size: 24,
                              ),
                            ),
                            tooltip: themeProvider.isDarkMode
                                ? 'Light Mode'
                                : 'Dark Mode',
                            onPressed: () => _toggleTheme(themeProvider),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: responsive.spacing * 2),

                // Logo
                _buildEclipseLogo(context, colorScheme, responsive, isDark),

                SizedBox(height: responsive.spacing * 3),

                // Title
                _buildTitle(context, colorScheme, responsive, isDark),

                SizedBox(height: responsive.spacing),

                // Current type indicator
                Text(
                  _qrTypes[_currentPage].title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: responsive.spacing * 0.5),

                // Swipe hint
                Text(
                  '← Swipe to change type →',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),

                SizedBox(height: responsive.spacing * 2),

                // Page indicators (dots)
                _buildPageIndicators(colorScheme),

                SizedBox(height: responsive.spacing * 2),

                // Swipe carousel (circular/infinite)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: null, // Infinite scrolling
                    itemBuilder: (context, index) {
                      final wrappedIndex = index % _qrTypes.length;
                      return _buildCarouselCard(
                        context,
                        _qrTypes[wrappedIndex],
                        colorScheme,
                        responsive,
                        isDark,
                      );
                    },
                  ),
                ),

                SizedBox(height: responsive.spacing * 3),

                // QR History Section
                if (_historyItems.isNotEmpty) ...[
                  _buildHistorySection(context, theme, colorScheme, responsive, isDark),
                  SizedBox(height: responsive.spacing * 2),
                ],

                // Footer
                _buildGalleryFooter(context, colorScheme, responsive, isDark),

                SizedBox(height: responsive.spacing * 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEclipseLogo(BuildContext context, ColorScheme colorScheme,
      Responsive responsive, bool isDark) {
    final logoSize = responsive.value(
      phone: 100.0,
      tablet: 120.0,
      desktop: 140.0,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: logoSize,
        height: logoSize,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: isDark
                ? [
                    colorScheme.surfaceVariant,
                    colorScheme.surface,
                  ]
                : [
                    Colors.white,
                    colorScheme.surfaceVariant.withValues(alpha: 0.5),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? colorScheme.primary : colorScheme.primary)
                  .withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 40,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/digital_disconnections_logo_only.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ColorScheme colorScheme,
      Responsive responsive, bool isDark) {
    return FadeSlideIn(
      delay: const Duration(milliseconds: 400),
      child: Text(
        'Digital Eclipse',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: colorScheme.onSurface,
              fontSize: responsive.value(
                phone: 32.0,
                tablet: 38.0,
                desktop: 44.0,
              ),
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPageIndicators(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_qrTypes.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildCarouselCard(
    BuildContext context,
    QRTypeData qrType,
    ColorScheme colorScheme,
    Responsive responsive,
    bool isDark,
  ) {
    return Padding(
      padding: responsive.horizontalPadding,
      child: GestureDetector(
        onTap: () => _navigateToGenerator(qrType.route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      colorScheme.surfaceVariant,
                      colorScheme.surfaceVariant.withValues(alpha: 0.8),
                    ]
                  : [
                      Colors.white,
                      colorScheme.surfaceVariant.withValues(alpha: 0.3),
                    ],
            ),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: qrType.primaryColor.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gradient
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      qrType.primaryColor,
                      qrType.secondaryColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: qrType.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  qrType.icon,
                  size: 56,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: responsive.spacing * 3),

              // Title
              Text(
                qrType.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.spacing),

              // Subtitle
              Text(
                qrType.subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: responsive.spacing * 4),

              // Tap to create button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      qrType.primaryColor,
                      qrType.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: qrType.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Tap to Create',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, ThemeData theme,
      ColorScheme colorScheme, Responsive responsive, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: responsive.horizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent QR Codes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (_historyItems.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    await _historyService.clearHistory();
                    _loadHistory();
                  },
                  child: const Text('Clear All'),
                ),
            ],
          ),
        ),

        SizedBox(height: responsive.spacing),

        // History items horizontal scroll
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: responsive.horizontalPadding,
            itemCount: _historyItems.length,
            itemBuilder: (context, index) {
              final item = _historyItems[index];
              return _buildHistoryCard(
                context,
                item,
                theme,
                colorScheme,
                responsive,
                isDark,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    QRHistoryItem item,
    ThemeData theme,
    ColorScheme colorScheme,
    Responsive responsive,
    bool isDark,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceVariant
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR code thumbnail
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(4),
            child: QrImageView(
              data: item.content,
              version: QrVersions.auto,
              size: 70,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: colorScheme.onSurface,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: colorScheme.onSurface,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),

          const SizedBox(height: 4),

          // Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              item.displayLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryFooter(BuildContext context, ColorScheme colorScheme,
      Responsive responsive, bool isDark) {
    return Column(
      children: [
        Divider(
          color: colorScheme.outline.withValues(alpha: 0.15),
          thickness: 1,
          indent: responsive.spacing * 4,
          endIndent: responsive.spacing * 4,
        ),
        SizedBox(height: responsive.spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'by ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
            ),
            GestureDetector(
              onTap: _launchWebsite,
              child: Text(
                BrandConstants.companyName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? colorScheme.primary
                          : BrandConstants.brandPrimary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QRTypeData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final String route;

  QRTypeData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.route,
  });
}

/// Background eclipse painter for gallery walls
class _EclipseBackgroundPainter extends CustomPainter {
  final Color color;

  _EclipseBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final center = Offset(size.width / 2, size.height / 2);
    final radiusX = size.width * 0.3;
    final radiusY = size.width * 0.2;

    // Left ellipse - tilted -25 degrees
    canvas.save();
    canvas.translate(center.dx - radiusX * 0.4, center.dy);
    canvas.rotate(-0.436);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radiusX * 2, height: radiusY * 2),
      paint,
    );
    canvas.restore();

    // Right ellipse - tilted +25 degrees
    canvas.save();
    canvas.translate(center.dx + radiusX * 0.4, center.dy);
    canvas.rotate(0.436);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radiusX * 2, height: radiusY * 2),
      paint,
    );
    canvas.restore();

    // Gradient overlay
    final gradient = RadialGradient(
      colors: [
        color.withValues(alpha: 0.05),
        color.withValues(alpha: 0.0),
      ],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: size.width / 2),
      );

    canvas.drawCircle(center, size.width / 2, gradientPaint);
  }

  @override
  bool shouldRepaint(_EclipseBackgroundPainter oldDelegate) => false;
}

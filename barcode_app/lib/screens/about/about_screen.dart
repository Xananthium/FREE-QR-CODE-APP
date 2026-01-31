import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/brand_constants.dart';
import '../../core/animations/widget_animations.dart';
import '../../core/utils/responsive.dart';
import '../../core/navigation/app_router.dart';

/// About screen showing app information and Digital Disconnections branding
/// 
/// Features:
/// - Company logo
/// - App description
/// - Company information
/// - Website link
/// - Beautiful animations
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchWebsite(BuildContext context) async {
    try {
      final uri = Uri.parse(BrandConstants.websiteUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open website')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening website: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.goBackOrHome(),
          tooltip: 'Back',
        ),
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: SingleChildScrollView(
            padding: responsive.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: responsive.spacing * 3),

                // Logo with fade-in animation
                FadeSlideIn(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(responsive.spacing),
                      color: Colors.white,
                      child: Image.asset(
                        BrandConstants.logoPath,
                        width: responsive.value(
                          phone: 200.0,
                          tablet: 250.0,
                          desktop: 300.0,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: responsive.spacing * 3),

                // App Name
                FadeSlideIn(
                  delay: const Duration(milliseconds: 150),
                  child: Text(
                    BrandConstants.appName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.value(
                        phone: 28.0,
                        tablet: 32.0,
                        desktop: 36.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: responsive.spacing),

                // App Description
                FadeSlideIn(
                  delay: const Duration(milliseconds: 300),
                  child: Container(
                    padding: responsive.padding,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      BrandConstants.aboutDescription,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: responsive.value(
                          phone: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: responsive.spacing * 3),

                // Our Story Section
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_stories_rounded,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          SizedBox(width: responsive.spacing),
                          Text(
                            'Our Story',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.value(
                                phone: 22.0,
                                tablet: 24.0,
                                desktop: 26.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.spacing * 1.5),
                      Container(
                        padding: responsive.padding,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          BrandConstants.ourStory,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: responsive.value(
                              phone: 15.0,
                              tablet: 17.0,
                              desktop: 19.0,
                            ),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: responsive.spacing * 3),

                // Free Forever Section
                FadeSlideIn(
                  delay: const Duration(milliseconds: 500),
                  child: Container(
                    padding: responsive.padding,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.1),
                          colorScheme.secondary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                        SizedBox(height: responsive.spacing),
                        Text(
                          'Free Forever',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            fontSize: responsive.value(
                              phone: 18.0,
                              tablet: 20.0,
                              desktop: 22.0,
                            ),
                          ),
                        ),
                        SizedBox(height: responsive.spacing),
                        Text(
                          BrandConstants.freeForever,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: responsive.value(
                              phone: 14.0,
                              tablet: 16.0,
                              desktop: 18.0,
                            ),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: responsive.spacing * 3),

                // Website Link Button
                FadeSlideIn(
                  delay: const Duration(milliseconds: 600),
                  child: FilledButton.icon(
                    onPressed: () => _launchWebsite(context),
                    icon: const Icon(Icons.language_rounded),
                    label: Text(
                      'Visit ${BrandConstants.companyName}',
                      style: TextStyle(
                        fontSize: responsive.value(
                          phone: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        ),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.spacing * 2.5,
                        vertical: responsive.spacing * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: responsive.spacing * 2),

                // Website URL
                FadeSlideIn(
                  delay: const Duration(milliseconds: 750),
                  child: GestureDetector(
                    onTap: () => _launchWebsite(context),
                    child: Text(
                      BrandConstants.websiteUrl,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        decoration: TextDecoration.underline,
                        fontSize: responsive.value(
                          phone: 14.0,
                          tablet: 16.0,
                          desktop: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: responsive.spacing * 4),

                // Version Info
                FadeSlideIn(
                  delay: const Duration(milliseconds: 900),
                  child: Text(
                    'Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: responsive.value(
                        phone: 12.0,
                        tablet: 14.0,
                        desktop: 16.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: responsive.spacing * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

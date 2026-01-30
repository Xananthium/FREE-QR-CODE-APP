import 'package:flutter/material.dart';

/// Screen size breakpoints for responsive design
class Breakpoints {
  /// Small screens (phones) - up to 600dp
  static const double small = 600;
  
  /// Medium screens (tablets) - 600dp to 1200dp
  static const double medium = 1200;
  
  /// Large screens (desktop/web) - above 1200dp
  static const double large = 1200;
  
  /// Extra large screens - above 1600dp
  static const double extraLarge = 1600;
}

/// Device type based on screen width
enum DeviceType {
  phone,
  tablet,
  desktop,
}

/// Responsive utility class for adaptive layouts
class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  /// Get screen width
  double get width => MediaQuery.of(context).size.width;
  
  /// Get screen height
  double get height => MediaQuery.of(context).size.height;
  
  /// Check if device is phone (small screen)
  bool get isPhone => width < Breakpoints.small;
  
  /// Check if device is tablet (medium screen)
  bool get isTablet => width >= Breakpoints.small && width < Breakpoints.medium;
  
  /// Check if device is desktop (large screen)
  bool get isDesktop => width >= Breakpoints.medium;
  
  /// Check if device is extra large desktop
  bool get isExtraLarge => width >= Breakpoints.extraLarge;
  
  /// Get current device type
  DeviceType get deviceType {
    if (isPhone) return DeviceType.phone;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  /// Get value based on device type
  T value<T>({
    required T phone,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? phone;
    if (isTablet) return tablet ?? phone;
    return phone;
  }
  
  /// Get responsive padding
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
    horizontal: value(
      phone: 16.0,
      tablet: 32.0,
      desktop: 48.0,
    ),
  );
  
  /// Get responsive vertical padding
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(
    vertical: value(
      phone: 12.0,
      tablet: 16.0,
      desktop: 24.0,
    ),
  );
  
  /// Get responsive padding
  EdgeInsets get padding => EdgeInsets.all(
    value(
      phone: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    ),
  );
  
  /// Get responsive spacing
  double get spacing => value(
    phone: 8.0,
    tablet: 12.0,
    desktop: 16.0,
  );
  
  /// Get responsive card spacing
  double get cardSpacing => value(
    phone: 16.0,
    tablet: 24.0,
    desktop: 32.0,
  );
  
  /// Get responsive icon size
  double get iconSize => value(
    phone: 24.0,
    tablet: 28.0,
    desktop: 32.0,
  );
  
  /// Get responsive max content width
  double get maxContentWidth => value(
    phone: double.infinity,
    tablet: 800.0,
    desktop: 1200.0,
  );
  
  /// Get number of columns for grid layout
  int get gridColumns => value(
    phone: 1,
    tablet: 2,
    desktop: 3,
  );
  
  /// Get grid aspect ratio
  double get gridAspectRatio => value(
    phone: 1.0,
    tablet: 1.2,
    desktop: 1.5,
  );
}

/// Extension to easily access Responsive from context
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}

/// Responsive builder widget for complex layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        return builder(context, deviceType);
      },
    );
  }
  
  DeviceType _getDeviceType(double width) {
    if (width < Breakpoints.small) return DeviceType.phone;
    if (width < Breakpoints.medium) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

/// Responsive layout widget with phone/tablet/desktop variants
class ResponsiveLayout extends StatelessWidget {
  final Widget phone;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.desktop:
            return desktop ?? tablet ?? phone;
          case DeviceType.tablet:
            return tablet ?? phone;
          case DeviceType.phone:
            return phone;
        }
      },
    );
  }
}

/// Responsive grid widget
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final int? phoneColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.phoneColumns,
    this.tabletColumns,
    this.desktopColumns,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final columns = responsive.value(
      phone: phoneColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    );
    
    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// Responsive center constraint - centers content with max width
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final width = maxWidth ?? responsive.maxContentWidth;
    
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}

/// Responsive row/column - switches between row and column based on screen size
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  final bool forceColumn;
  
  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 8.0,
    this.forceColumn = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final useColumn = forceColumn || responsive.isPhone;
    
    final spacer = SizedBox(
      width: useColumn ? 0 : spacing,
      height: useColumn ? spacing : 0,
    );
    
    final childrenWithSpacing = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      childrenWithSpacing.add(children[i]);
      if (i < children.length - 1) {
        childrenWithSpacing.add(spacer);
      }
    }
    
    if (useColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: childrenWithSpacing,
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: childrenWithSpacing,
      );
    }
  }
}

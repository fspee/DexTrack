import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

class DexCard extends StatelessWidget {
  const DexCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.medium),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decoration = BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      border: Border.all(
        color: theme.colorScheme.outline,
      ),
    );

    if (onTap == null) {
      return Container(
        width: double.infinity,
        padding: padding,
        decoration: decoration,
        child: child,
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Ink(
          width: double.infinity,
          padding: padding,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}
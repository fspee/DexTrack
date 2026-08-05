import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'dex_card.dart';

class DexStatCard extends StatelessWidget {
  const DexStatCard({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DexCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colors.primary,
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            value,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
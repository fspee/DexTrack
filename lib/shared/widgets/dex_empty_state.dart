import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import 'dex_card.dart';

class DexEmptyState extends StatelessWidget {
  const DexEmptyState({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return DexCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(
              icon,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.small),
            Icon(
              Icons.chevron_right,
              color: colors.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}
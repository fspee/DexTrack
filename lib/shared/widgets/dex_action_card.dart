import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

class DexActionCard extends StatelessWidget {
  const DexActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.primary,
      borderRadius: BorderRadius.circular(AppRadius.xLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colors.onPrimary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
                  icon,
                  color: colors.onPrimary,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onPrimary.withValues(alpha: 0.78),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Icon(
                Icons.arrow_forward,
                color: colors.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
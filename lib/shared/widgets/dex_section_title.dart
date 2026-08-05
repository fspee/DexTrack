import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class DexSectionTitle extends StatelessWidget {
  const DexSectionTitle({
    required this.title,
    super.key,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
        ),
        if (actionLabel != null && onActionPressed != null) ...[
          const SizedBox(width: AppSpacing.small),
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionLabel!),
          ),
        ],
      ],
    );
  }
}
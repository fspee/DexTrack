import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

class DexNetworkImage extends StatelessWidget {
  const DexNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadius.small,
    this.placeholder,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final fallback = placeholder ?? _DefaultPlaceholder(
      width: width,
      height: height,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageUrl.isEmpty
          ? fallback
          : CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              fit: fit,
              fadeInDuration: const Duration(milliseconds: 180),
              placeholder: (_, _) => fallback,
              errorWidget: (_, _, _) => fallback,
            ),
    );
  }
}

class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder({
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.style_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
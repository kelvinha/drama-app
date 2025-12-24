import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Custom Avatar Widget
/// Avatar dengan gradient background

class AppAvatar extends StatelessWidget {
  final String? text;
  final String? imageUrl;
  final double size;
  final int? colorIndex;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.text,
    this.imageUrl,
    this.size = 50,
    this.colorIndex,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        backgroundColor ??
        (colorIndex != null
            ? AppColors.getAccentColor(colorIndex!)
            : AppColors.primary);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size / 3.5),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 3.5),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildTextAvatar(),
              ),
            )
          : _buildTextAvatar(),
    );
  }

  Widget _buildTextAvatar() {
    final displayText = text?.isNotEmpty == true ? text![0].toUpperCase() : '?';

    return Center(
      child: Text(
        displayText,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

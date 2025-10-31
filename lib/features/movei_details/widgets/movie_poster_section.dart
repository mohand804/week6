import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:week6/core/networking/api_constants.dart';

class MoviePosterSection extends StatelessWidget {
  final String posterUrl;

  const MoviePosterSection({super.key, required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 180.w,
      height: 270.h,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[300],
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.network(
        '${ApiConstants.imageUrl}$posterUrl',
        fit: BoxFit.cover,
      ),
    );
  }
}

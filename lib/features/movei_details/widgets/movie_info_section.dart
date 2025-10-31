import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:week6/core/helpers/spacing.dart';

class MovieInfoSection extends StatelessWidget {
  final String title;
  final double rating;
  final String genre;

  const MovieInfoSection({
    super.key,
    required this.title,
    required this.rating,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpace(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20.sp),
            horizontalSpace(6),
            Text(
              '$rating / 10',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            horizontalSpace(16),
          ],
        ),
        verticalSpace(10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[200],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            genre,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

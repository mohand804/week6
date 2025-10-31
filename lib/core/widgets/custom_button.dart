import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;
  final bool isLoading;
  final WidgetStateProperty<Color?>? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton({
    this.borderColor,
    super.key,
    required this.text,
    this.style,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            backgroundColor ??
            WidgetStateProperty.all(
              onPressed == null
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
                  : Theme.of(context).colorScheme.primary,
            ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 52)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? Colors.transparent),
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
        ),
      ),
      child:
          isLoading || onPressed == null
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        style?.color ?? Colors.white,
                      ),
                    ),
                  ),
                ],
              )
              : Text(text, style: style),
    );
  }
}

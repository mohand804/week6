import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:week6/core/helpers/spacing.dart';

class CustomTextField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool? enabled;
  final InputDecoration? decoration;
  final int? maxLength;
  final int? minLines;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final bool? readOnly;
  final VoidCallback? onTap;
  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.enabled,
    this.decoration,
    this.obscureText,
    this.maxLength,
    this.suffixIcon,
    this.fillColor,
    this.prefix,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FormField<String>(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onTap: onTap,
              obscureText: obscureText ?? false,
              readOnly: readOnly ?? false,
              enabled: enabled,
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLines: maxLines ?? 1,
              minLines: minLines,
              maxLength: maxLength,
              autovalidateMode: AutovalidateMode.disabled,
              decoration:
                  (decoration ??
                          InputDecoration(
                            prefix: prefix,
                            contentPadding:
                                contentPadding ??
                                EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 12.w,
                                ),
                            suffixIcon: suffixIcon,
                            fillColor: isDarkMode ? Colors.black : Colors.white,
                            filled: true,
                            labelText: labelText,
                            hintText: hintText,
                            hintStyle:
                                hintStyle ?? TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ))
                      .copyWith(errorText: null),
              onChanged: (value) {
                formFieldState.didChange(value);
              },
            ),
            verticalSpace(4),
            if (formFieldState.hasError)
              Text(
                formFieldState.errorText ?? '',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.sp,
                  height: 1.2.h,
                ),
              )
            else
              verticalSpace(0),
          ],
        );
      },
    );
  }
}

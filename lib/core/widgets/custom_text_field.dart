import 'package:flutter/material.dart';
import 'global_input_field.dart';

/// Global reusable Custom Text Form Field widget powered by GlobalInputField.
/// Retains full backward compatibility with existing forms while providing
/// modern floating label styling, theme green focus glow, and dark mode support.
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    IconData? extractedPrefixIcon;
    if (prefixIcon is Icon) {
      extractedPrefixIcon = (prefixIcon as Icon).icon;
    }

    return GlobalInputField(
      controller: controller,
      label: label,
      hintText: hintText,
      prefixIcon: extractedPrefixIcon,
      suffixWidget: suffixIcon,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/widgets/global_input_field.dart';

/// High-fidelity Login Input Field powered by GlobalInputField.
/// Retains the established Login interface while delivering the modern
/// floating label experience, theme focus ring, and clean dark mode styling.
class LoginInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const LoginInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalInputField(
      controller: controller ?? TextEditingController(),
      label: label,
      hintText: hintText,
      prefixIcon: icon,
      suffixWidget: suffixIcon,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}

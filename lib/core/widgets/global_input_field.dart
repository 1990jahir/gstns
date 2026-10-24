import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../res/color_manager.dart';

enum InputValidationState { none, valid, error }

/// Custom text input formatter to enforce uppercase text
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Global Pixel-perfect Floating Label Input Box
/// Designed to be used universally across the entire application:
/// - Supports both manual validation and standard Flutter Form validation (FormFieldValidator)
/// - Supports prefix icons (IconData), prefix text (e.g. '+91'), and suffix widgets
/// - Fixed 56px height with stable text baseline that doesn't jump
/// - Animated floating label with theme focus glow and dark mode support
class GlobalInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixWidget;
  final Widget? suffixIcon;
  final double suffixWidth;
  final Widget? bottomWidget;
  final String? messageText;
  final bool isMessageOk;
  final InputValidationState validationState;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final Color? backgroundColor;

  const GlobalInputField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.prefixText,
    this.suffixWidget,
    this.suffixIcon,
    this.suffixWidth = 0.0,
    this.bottomWidget,
    this.messageText,
    this.isMessageOk = false,
    this.validationState = InputValidationState.none,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofocus = false,
    this.onChanged,
    this.onEditingComplete,
    this.focusNode,
    this.validator,
    this.fillColor,
    this.backgroundColor,
  });

  @override
  State<GlobalInputField> createState() => _GlobalInputFieldState();
}

class _GlobalInputFieldState extends State<GlobalInputField> {
  late FocusNode _focusNode;
  bool _isInternalFocusNode = false;
  late TextEditingController _effectiveController;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }

    if (widget.controller != null) {
      _effectiveController = widget.controller!;
    } else {
      _effectiveController = TextEditingController();
      _isInternalController = true;
    }

    _focusNode.addListener(_handleFocusChange);
    _effectiveController.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant GlobalInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      if (_isInternalFocusNode) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _isInternalFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _isInternalFocusNode = true;
      }
      _focusNode.addListener(_handleFocusChange);
    }
    if (widget.controller != oldWidget.controller) {
      if (_isInternalController) {
        _effectiveController.removeListener(_handleTextChange);
        _effectiveController.dispose();
      } else {
        oldWidget.controller?.removeListener(_handleTextChange);
      }
      if (widget.controller != null) {
        _effectiveController = widget.controller!;
        _isInternalController = false;
      } else {
        _effectiveController = TextEditingController();
        _isInternalController = true;
      }
      _effectiveController.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    _effectiveController.removeListener(_handleTextChange);
    if (_isInternalController) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  void _handleTextChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.validator != null) {
      return FormField<String>(
        validator: widget.validator,
        initialValue: _effectiveController.text,
        builder: (FormFieldState<String> fieldState) {
          final effectiveValidation = fieldState.hasError
              ? InputValidationState.error
              : widget.validationState;
          final effectiveMessage = fieldState.errorText ?? widget.messageText;
          final effectiveIsOk = fieldState.hasError ? false : widget.isMessageOk;

          return _buildInputField(
            context,
            effectiveValidationState: effectiveValidation,
            effectiveMessageText: effectiveMessage,
            effectiveIsMessageOk: effectiveIsOk,
            onChangedInternal: (val) {
              fieldState.didChange(val);
              widget.onChanged?.call(val);
            },
          );
        },
      );
    }

    return _buildInputField(
      context,
      effectiveValidationState: widget.validationState,
      effectiveMessageText: widget.messageText,
      effectiveIsMessageOk: widget.isMessageOk,
      onChangedInternal: widget.onChanged,
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required InputValidationState effectiveValidationState,
    required String? effectiveMessageText,
    required bool effectiveIsMessageOk,
    required ValueChanged<String>? onChangedInternal,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFocused = _focusNode.hasFocus;
    final hasText = _effectiveController.text.isNotEmpty;
    final isFloating = isFocused || hasText;

    final surfaceBg = widget.backgroundColor ?? widget.fillColor ?? (isDark ? ColorManager.darkCardSurface : Colors.white);
    final lineColor = isDark ? ColorManager.darkBorderColor : ColorManager.lightBorder;
    final textColor = isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary;
    final mutedColor = isDark ? ColorManager.darkTextSecondary : ColorManager.lightTextSecondary;
    final brandColor = ColorManager.primaryGreen;

    Color borderColor;
    if (effectiveValidationState == InputValidationState.error) {
      borderColor = ColorManager.red;
    } else if (effectiveValidationState == InputValidationState.valid) {
      borderColor = brandColor;
    } else if (isFocused) {
      borderColor = brandColor;
    } else {
      borderColor = lineColor;
    }

    final hasPrefixText = widget.prefixText != null && widget.prefixText!.isNotEmpty;
    final hasPrefixIcon = widget.prefixIcon != null;
    final suffixChild = widget.suffixWidget ?? widget.suffixIcon;
    final effectiveSuffixWidth = suffixChild != null
        ? (widget.suffixWidth > 0 ? widget.suffixWidth : 42.0)
        : 0.0;

    final double contentLeft = hasPrefixIcon ? 42.0 : 14.0;
    final double labelLeft = hasPrefixIcon ? 42.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 56,
          decoration: BoxDecoration(
            color: surfaceBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: isFocused || effectiveValidationState != InputValidationState.none ? 1.5 : 1.2,
            ),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: brandColor.withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Prefix Icon
              if (hasPrefixIcon)
                Positioned(
                  left: 14,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      widget.prefixIcon,
                      size: 20,
                      color: isFocused ? brandColor : mutedColor,
                    ),
                  ),
                ),

              // TextField and optional prefix text
              Positioned(
                left: contentLeft,
                right: suffixChild != null ? (effectiveSuffixWidth + 12) : 14,
                top: 0,
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (hasPrefixText && isFloating) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 17.0, right: 6.0),
                        child: Text(
                          widget.prefixText!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: mutedColor,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: isFloating ? 17.0 : 0.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              filled: false,
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                            textSelectionTheme: TextSelectionThemeData(
                              cursorColor: brandColor,
                              selectionColor: brandColor.withValues(alpha: 0.20),
                              selectionHandleColor: brandColor,
                            ),
                          ),
                          child: TextField(
                            controller: _effectiveController,
                            focusNode: _focusNode,
                            obscureText: widget.obscureText,
                            keyboardType: widget.keyboardType,
                            textCapitalization: widget.textCapitalization,
                            inputFormatters: widget.inputFormatters,
                            autofocus: widget.autofocus,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Inter',
                              letterSpacing: widget.textCapitalization == TextCapitalization.characters ? 0.6 : 0.0,
                            ),
                            cursorColor: brandColor,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: false,
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              hintText: isFloating ? widget.hintText : null,
                              hintStyle: TextStyle(
                                color: mutedColor.withValues(alpha: 0.6),
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onChanged: onChangedInternal,
                            onEditingComplete: widget.onEditingComplete,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Animated Floating Label
              Positioned(
                left: labelLeft,
                top: isFloating ? 7 : 18,
                child: IgnorePointer(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    style: TextStyle(
                      fontSize: isFloating ? 11.0 : 14.5,
                      fontWeight: isFloating ? FontWeight.w700 : FontWeight.w500,
                      color: isFocused
                          ? brandColor
                          : (effectiveValidationState == InputValidationState.error
                              ? ColorManager.red
                              : mutedColor),
                      fontFamily: 'Inter',
                    ),
                    child: Text(widget.label),
                  ),
                ),
              ),

              // Right-aligned Suffix Widget (Verify chip, Eye toggle)
              if (suffixChild != null)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: suffixChild,
                  ),
                ),

              // Optional bottom widget (e.g. password strength meter)
              if (widget.bottomWidget != null)
                Positioned(
                  left: labelLeft,
                  right: 14,
                  bottom: 4,
                  child: widget.bottomWidget!,
                ),
            ],
          ),
        ),

        // Helper or Error Message
        if (effectiveMessageText != null && effectiveMessageText.isNotEmpty) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              effectiveMessageText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: effectiveIsMessageOk ? brandColor : ColorManager.red,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ],
    );
  }
}

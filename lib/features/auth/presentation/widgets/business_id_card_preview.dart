import 'package:flutter/material.dart';
import '../../../../core/res/color_manager.dart';

/// Digital Business ID / GST Card Preview
/// Styled with the client's official Forest Green theme palette:
/// - LinearGradient from ColorManager.primaryGreen -> primaryGreenDark -> deepForestGreen
/// - Tri-color Indian flag pill
/// - Dynamic status indicator badge ('GST registered', '✓ GST verified', or 'Unregistered')
/// - Real-time company name, grouped GSTIN chunks, owner name, and formatted mobile
/// - Geometric circular accents and animated shine / gleam sweep effect on verification
class BusinessIdCardPreview extends StatefulWidget {
  final String companyName;
  final String gstin;
  final String ownerName;
  final String phoneNumber;
  final bool isRegistered;
  final bool isVerified;
  final bool triggerShine;

  const BusinessIdCardPreview({
    super.key,
    required this.companyName,
    required this.gstin,
    required this.ownerName,
    required this.phoneNumber,
    this.isRegistered = true,
    this.isVerified = false,
    this.triggerShine = false,
  });

  @override
  State<BusinessIdCardPreview> createState() => _BusinessIdCardPreviewState();
}

class _BusinessIdCardPreviewState extends State<BusinessIdCardPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shineAnimation = Tween<double>(begin: -1.4, end: 1.4).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    if (widget.triggerShine) {
      _shineController.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant BusinessIdCardPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerShine && !oldWidget.triggerShine) {
      _shineController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  /// Formats raw 15-char GSTIN into spaced chunks: 2, 5, 4, 1, 1, 1, 1
  /// Example: "27AAAAA1234A1Z5" -> "27 AAAAA 1234 A 1 Z 5"
  String _formatGstin(String raw) {
    if (!widget.isRegistered) return 'No GSTIN';
    final padded = raw.padRight(15, '•').toUpperCase();
    final groups = [2, 5, 4, 1, 1, 1, 1];
    final parts = <String>[];
    int start = 0;
    for (final len in groups) {
      if (start < padded.length) {
        final end = (start + len).clamp(0, padded.length);
        parts.add(padded.substring(start, end));
        start = end;
      }
    }
    return parts.join(' ');
  }

  String _formatPhone(String raw) {
    final clean = raw.replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) return '+91 ••••• •••••';
    if (clean.length <= 5) {
      return '+91 $clean';
    }
    return '+91 ${clean.substring(0, 5)} ${clean.substring(5)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasCompany = widget.companyName.trim().isNotEmpty;
    final displayCompany = hasCompany ? widget.companyName.trim() : 'Your company name';

    final hasGstin = widget.gstin.trim().isNotEmpty;
    final displayGst = _formatGstin(widget.gstin.trim());

    final hasOwner = widget.ownerName.trim().isNotEmpty;
    final displayOwner = hasOwner ? widget.ownerName.trim() : 'Your name';

    final displayPhone = _formatPhone(widget.phoneNumber);

    String statusText;
    Color statusBg;
    Border? statusBorder;

    if (!widget.isRegistered) {
      statusText = 'Unregistered';
      statusBg = Colors.white.withValues(alpha: 0.12);
      statusBorder = null;
    } else if (widget.isVerified) {
      statusText = '✓ GST verified';
      statusBg = ColorManager.accentGreen.withValues(alpha: 0.28);
      statusBorder = Border.all(
        color: ColorManager.accentGreen.withValues(alpha: 0.6),
        width: 1.0,
      );
    } else {
      statusText = 'GST registered';
      statusBg = Colors.white.withValues(alpha: 0.14);
      statusBorder = null;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      height: 158,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.authCardBgStart,
            ColorManager.authCardBgMid,
            ColorManager.authCardBgEnd,
          ],
          stops: [0.0, 0.52, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryGreen.withValues(alpha: 0.38),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Geometric circle accent 1: Top Right Ring (Orange Tint)
          Positioned(
            right: -48,
            top: -58,
            child: IgnorePointer(
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.authSun.withValues(alpha: 0.22),
                    width: 26,
                  ),
                ),
              ),
            ),
          ),

          // Geometric circle accent 2: Bottom Left Glow (Accent Green)
          Positioned(
            left: -40,
            bottom: -80,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.accentGreen.withValues(alpha: 0.16),
                ),
              ),
            ),
          ),

          // Animated Shine Light Sweep
          AnimatedBuilder(
            animation: _shineController,
            builder: (context, child) {
              if (!_shineController.isAnimating) return const SizedBox.shrink();
              return Positioned.fill(
                child: FractionalTranslation(
                  translation: Offset(_shineAnimation.value, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.28),
                          Colors.white.withValues(alpha: 0.0),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.35, 0.50, 0.65, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row (Flag + Status Pill)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Indian Tri-color Flag Pill
                    Container(
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: const [
                          Expanded(child: ColoredBox(color: ColorManager.flagOrange)),
                          Expanded(child: ColoredBox(color: ColorManager.flagWhite)),
                          Expanded(child: ColoredBox(color: ColorManager.flagGreen)),
                        ],
                      ),
                    ),

                    // Status Pill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(99),
                        border: statusBorder,
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),

                // Middle Section: Company Name & GSTIN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayCompany,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 18.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: Colors.white.withValues(alpha: hasCompany ? 1.0 : 0.45),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      displayGst,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                        color: Colors.white.withValues(
                          alpha: (!widget.isRegistered || hasGstin) ? 0.95 : 0.45,
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom Row: Owner & Mobile Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Owner
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Owner',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          displayOwner,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: hasOwner ? 0.95 : 0.45),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),

                    // Mobile
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Mobile',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          displayPhone,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(
                              alpha: widget.phoneNumber.isNotEmpty ? 0.95 : 0.45,
                            ),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

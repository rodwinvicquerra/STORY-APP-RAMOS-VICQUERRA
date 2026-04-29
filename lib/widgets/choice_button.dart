import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';

class ChoiceButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final int index;

  const ChoiceButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.index,
  });

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.buttonPressAnimation,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) async {
    await _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  // Modern gradient options for premium feel
  static const List<List<Color>> _gradients = [
    [AppColors.accentRed, AppColors.accentPink],
    [AppColors.accentPink, AppColors.accentBlue],
    [AppColors.accentBlue, AppColors.accentRed],
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = _gradients[widget.index % _gradients.length];

    return MouseRegion(
      onEnter: (_) {
        if (!_controller.isAnimating) {
          _controller.forward();
        }
      },
      onExit: (_) {
        if (_controller.status == AnimationStatus.forward) {
          _controller.reverse();
        }
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: AppSizes.buttonMinHeight),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.buttonPadding,
              horizontal: AppSizes.spacingSm,
            ),
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: AppFontSizes.buttonTextSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

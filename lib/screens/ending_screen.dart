import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/providers/app_settings.dart';
import 'splash_screen.dart';
import 'settings_screen.dart';

class EndingScreen extends StatefulWidget {
  final String endingType; // 'good', 'bad', 'neutral', 'weird'
  final String endingTitle;
  final String endingMessage;

  const EndingScreen({
    super.key,
    required this.endingType,
    required this.endingTitle,
    required this.endingMessage,
  });

  @override
  State<EndingScreen> createState() => _EndingScreenState();
}

class _EndingScreenState extends State<EndingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _scaleCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: AppDurations.endingFadeAnimation,
    )..forward();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: AppDurations.endingScaleAnimation,
    )..forward();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: AppDurations.endingPulseAnimation,
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  _EndingConfig get _config {
    switch (widget.endingType) {
      case 'good':
        return _EndingConfig(
          bg1: AppColors.endingGoodBg1,
          bg2: AppColors.endingGoodBg2,
          accent: AppColors.endingGood,
          icon: Icons.emoji_events_rounded,
          label: 'GOOD ENDING',
          labelColor: AppColors.endingGoodLight,
        );
      case 'bad':
        return _EndingConfig(
          bg1: AppColors.endingBadBg1,
          bg2: AppColors.endingBadBg2,
          accent: AppColors.endingBad,
          icon: Icons.sentiment_very_dissatisfied_rounded,
          label: 'BAD ENDING',
          labelColor: AppColors.endingBadLight,
        );
      case 'weird':
        return _EndingConfig(
          bg1: AppColors.endingWeirdBg1,
          bg2: AppColors.endingWeirdBg2,
          accent: AppColors.endingWeird,
          icon: Icons.auto_awesome_rounded,
          label: 'WEIRD ENDING',
          labelColor: AppColors.endingWeird,
        );
      default: // neutral
        return _EndingConfig(
          bg1: AppColors.endingNeutralBg1,
          bg2: AppColors.endingNeutralBg2,
          accent: AppColors.endingNeutral,
          icon: Icons.sentiment_neutral_rounded,
          label: 'NEUTRAL ENDING',
          labelColor: AppColors.endingNeutralLight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _config;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cfg.bg1, cfg.bg2],
              ),
            ),
          ),
          // Subtle radial glow
          Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    cfg.accent.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Ending type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: cfg.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: cfg.accent.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        cfg.label,
                        style: GoogleFonts.cinzel(
                          color: cfg.labelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Animated icon
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: AppSizes.endingIconSize,
                        height: AppSizes.endingIconSize,
                        decoration: BoxDecoration(
                          color: cfg.accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: cfg.accent, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: cfg.accent.withValues(alpha: 0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(cfg.icon, size: 58, color: cfg.accent),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Ending title
                    Text(
                      widget.endingTitle,
                      style: GoogleFonts.cinzel(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    Container(
                      height: 2,
                      width: 60,
                      decoration: BoxDecoration(
                        color: cfg.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Ending message card
                    Card(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: cfg.accent.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          widget.endingMessage,
                          style: GoogleFonts.nunito(
                            color: AppColors.textLight,
                            fontSize: 15,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    // RESTART button
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, 'restart'),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                cfg.accent,
                                cfg.accent.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: cfg.accent.withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.replay_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'PLAY AGAIN',
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Back to menu
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Back to Main Menu',
                        style: GoogleFonts.nunito(
                          color: Colors.white54,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Settings button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_rounded, size: 16),
                      label: const Text('Settings'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.accentBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EndingConfig {
  final Color bg1, bg2, accent, labelColor;
  final IconData icon;
  final String label;

  const _EndingConfig({
    required this.bg1,
    required this.bg2,
    required this.accent,
    required this.icon,
    required this.label,
    required this.labelColor,
  });
}

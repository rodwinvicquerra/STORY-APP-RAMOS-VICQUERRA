import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= AppSizes.tabletMinWidth;
    final isMobile = screenWidth < AppSizes.tabletMinWidth;

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
          // Content - Responsive layout
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: isDesktop ? _buildDesktopLayout(cfg) : _buildMobileLayout(cfg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(_EndingConfig cfg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          _buildBadge(cfg),
          const SizedBox(height: AppSizes.spacingMd),
          _buildAnimatedIcon(cfg),
          const SizedBox(height: AppSizes.spacingMd),
          _buildTitle(cfg),
          const SizedBox(height: AppSizes.spacingSm),
          _buildDivider(cfg),
          const SizedBox(height: AppSizes.spacingSm),
          _buildMessageCard(cfg),
          const Spacer(flex: 2),
          _buildPlayAgainButton(cfg),
          const SizedBox(height: AppSizes.spacingSm),
          _buildBottomButtons(),
          const SizedBox(height: AppSizes.spacingXs),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(_EndingConfig cfg) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingLg),
      child: Row(
        children: [
          // Left side - Image placeholder or artwork
          Expanded(
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppSizes.largeCardBorderRadius),
                    border: Border.all(
                      color: cfg.accent.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cfg.accent.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(cfg.icon, size: 120, color: cfg.accent.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacingLg),
          // Right side - Text and buttons
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadge(cfg),
                const SizedBox(height: AppSizes.spacingMd),
                _buildTitle(cfg),
                const SizedBox(height: AppSizes.spacingSm),
                _buildDivider(cfg),
                const SizedBox(height: AppSizes.spacingMd),
                Expanded(
                  child: _buildMessageCard(cfg),
                ),
                const SizedBox(height: AppSizes.spacingMd),
                _buildPlayAgainButton(cfg),
                const SizedBox(height: AppSizes.spacingSm),
                _buildBottomButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(_EndingConfig cfg) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSm,
        vertical: AppSizes.spacingXs,
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
          fontSize: AppFontSizes.small,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(_EndingConfig cfg) {
    return ScaleTransition(
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
    );
  }

  Widget _buildTitle(_EndingConfig cfg) {
    return Text(
      widget.endingTitle,
      style: GoogleFonts.cinzel(
        color: Colors.white,
        fontSize: AppFontSizes.heading,
        fontWeight: FontWeight.w900,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDivider(_EndingConfig cfg) {
    return Container(
      height: 2,
      width: 60,
      decoration: BoxDecoration(
        color: cfg.accent,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildMessageCard(_EndingConfig cfg) {
    return Card(
      color: Colors.black.withValues(alpha: 0.3),
      elevation: AppSizes.cardElevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
        side: BorderSide(
          color: cfg.accent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMd),
        child: Text(
          widget.endingMessage,
          style: GoogleFonts.nunito(
            color: AppColors.textLight,
            fontSize: AppFontSizes.subtitle,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPlayAgainButton(_EndingConfig cfg) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.pop(context, 'restart');
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: AppSizes.buttonMinHeight),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.buttonPadding,
          horizontal: AppSizes.spacingSm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cfg.accent,
              cfg.accent.withValues(alpha: 0.7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
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
            const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
            const SizedBox(width: AppSizes.spacingXs),
            Text(
              'PLAY AGAIN',
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: AppFontSizes.title,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SplashScreen()),
              (route) => false,
            );
          },
          child: Text(
            'Back to Main Menu',
            style: GoogleFonts.nunito(
              color: Colors.white54,
              fontSize: AppFontSizes.body,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white54,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings_rounded, size: 16),
          label: const Text('Settings'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentBlue,
          ),
        ),
      ],
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'story_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: AppDurations.splashFadeAnimation,
    );
    _slideController = AnimationController(
      vsync: this,
      duration: AppDurations.splashSlideAnimation,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: AppDurations.splashPulseAnimation,
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(AppDurations.splashDelayBeforeStart, () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppAssets.splashBgImage,
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark.withValues(alpha: 0.8),
                    AppColors.primaryDark.withValues(alpha: 0.96),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      // Flash drive icon
                      Container(
                        width: AppSizes.usbIconSize,
                        height: AppSizes.usbIconSize,
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentRed,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.usb_rounded,
                          size: AppSizes.iconSize,
                          color: AppColors.accentRed,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Title
                      Text(
                        'THE MISSING',
                        style: GoogleFonts.cinzel(
                          color: AppColors.accentRed,
                          fontSize: AppFontSizes.splashTitleSmall,
                          fontWeight: FontWeight.w700,
                          letterSpacing: AppLetterSpacing.splashTitle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'FLASH DRIVE',
                        style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: AppFontSizes.splashTitleLarge,
                          fontWeight: FontWeight.w900,
                          letterSpacing: AppLetterSpacing.splashSubtitle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      // Subtitle
                      Text(
                        AppStrings.subtitle,
                        style: GoogleFonts.nunito(
                          color: AppColors.accentBlue,
                          fontSize: AppFontSizes.splashSubtitleSize,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                      // Story teaser
                      Container(
                        padding: const EdgeInsets.all(AppSizes.paddingMedium),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.surfaceMedium,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '⏰ It\'s 4:30 PM. Your final IT project is due in 30 minutes.\n'
                          'You reach into your bag... and your flash drive is GONE.\n\n'
                          'Every choice you make leads to a different fate.',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFFB0BEC5),
                            fontSize: 13.5,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(flex: 1),
                      // START button with pulse animation
                      ScaleTransition(
                        scale: _pulseAnim,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, _, _) =>
                                    const StoryScreen(),
                                transitionsBuilder: (_, anim, _, child) =>
                                    FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                                transitionDuration:
                                    const Duration(milliseconds: 600),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE94560), Color(0xFFB71C3A)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentRed
                                      .withValues(alpha: 0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              '▶  START ADVENTURE',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cinzel(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                      // AI disclaimer
                      Text(
                        '🤖 Scene images are AI-generated',
                        style: GoogleFonts.nunito(
                          color: AppColors.textDimmed.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

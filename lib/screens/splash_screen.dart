import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/providers/app_settings.dart';
import 'story_screen.dart';
import 'settings_screen.dart';

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
      backgroundColor: AppColors.bgDarkBlack,
      body: Stack(
        children: [
          // Premium gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.bgDarkNavy, AppColors.bgDarkBlack],
              ),
            ),
          ),

          // Radial glow in center
          Center(
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentRed.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with glowing circle
                        ScaleTransition(
                          scale: _pulseAnim,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentRed.withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppColors.accentRed,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentRed.withValues(alpha: 0.4),
                                  blurRadius: 40,
                                  spreadRadius: 15,
                                ),
                                BoxShadow(
                                  color: AppColors.accentRed.withValues(alpha: 0.15),
                                  blurRadius: 80,
                                  spreadRadius: 30,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.usb_rounded,
                              size: 70,
                              color: AppColors.accentRed,
                            ),
                          ),
                        ),

                        const SizedBox(height: 56),

                        // Main title with spaced letters
                        Text(
                          'THE MISSING',
                          style: GoogleFonts.poppins(
                            color: AppColors.accentRed,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'FLASH DRIVE',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: AppFontSizes.extraLarge,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          'An Adventure in Choices',
                          style: GoogleFonts.poppins(
                            color: AppColors.accentBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 48),

                        // Story preview card (glass style)
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 48,
                          ),
                          padding: const EdgeInsets.all(AppSizes.spacingMd),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
                            border: Border.all(
                              color: AppColors.accentBlue.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            '⏰ It\'s 4:30 PM. Your final IT project is due in 30 minutes.\n'
                            'You reach into your bag... and your flash drive is GONE.\n\n'
                            'Every choice you make leads to a different fate.',
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.7,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // START ADVENTURE button
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 48,
                          ),
                          child: ScaleTransition(
                            scale: _pulseAnim,
                            child: GestureDetector(
                              onTap: () {
                                final settings = context.read<AppSettings>();
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
                                    transitionDuration: settings.skipAnimations
                                        ? Duration.zero
                                        : const Duration(milliseconds: 600),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: AppSizes.buttonMinHeight,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.buttonPadding,
                                  vertical: AppSizes.spacingSm,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.accentRed,
                                      AppColors.accentPink,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonBorderRadius,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentRed.withValues(alpha: 0.5),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: AppColors.accentRed.withValues(alpha: 0.15),
                                      blurRadius: 60,
                                      spreadRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '▶  START ADVENTURE',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

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
                          icon: const Icon(
                            Icons.settings_rounded,
                            size: 20,
                            color: AppColors.accentBlue,
                          ),
                          label: Text(
                            'Settings',
                            style: GoogleFonts.poppins(
                              color: AppColors.accentBlue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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

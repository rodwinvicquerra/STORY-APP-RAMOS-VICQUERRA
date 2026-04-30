import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/providers/app_settings.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryDarker,
    ),
  );
  runApp(const MissingFlashDriveApp());
}

class MissingFlashDriveApp extends StatelessWidget {
  const MissingFlashDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.bgDarkBlack,
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentRed,
            secondary: AppColors.accentBlue,
            surface: AppColors.surfaceLight,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimary,
          ),
          textTheme: TextTheme(
            // Titles (36-42)
            displayLarge: GoogleFonts.poppins(
              fontSize: AppFontSizes.titleLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
            displayMedium: GoogleFonts.poppins(
              fontSize: AppFontSizes.title,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            // Scene titles (24-28)
            headlineLarge: GoogleFonts.poppins(
              fontSize: AppFontSizes.sceneTitleLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            headlineMedium: GoogleFonts.poppins(
              fontSize: AppFontSizes.sceneTitle,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            // Body text (18-20)
            bodyLarge: GoogleFonts.poppins(
              fontSize: AppFontSizes.bodyLarge,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.6,
              letterSpacing: 0.2,
            ),
            bodyMedium: GoogleFonts.poppins(
              fontSize: AppFontSizes.body,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            bodySmall: GoogleFonts.poppins(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
            // Labels and buttons (18)
            labelLarge: GoogleFonts.poppins(
              fontSize: AppFontSizes.button,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            labelMedium: GoogleFonts.poppins(
              fontSize: AppFontSizes.buttonSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          cardTheme: CardThemeData(
            color: AppColors.surfaceLight.withOpacity(0.05),
            elevation: AppSizes.cardElevationMedium,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
              borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(double.infinity, 60),
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 8,
              shadowColor: AppColors.accentRed.withOpacity(0.5),
              textStyle: GoogleFonts.poppins(
                fontSize: AppFontSizes.button,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryDarker,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.accentBlue),
            surfaceTintColor: Colors.transparent,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: AppFontSizes.appBarTitleSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

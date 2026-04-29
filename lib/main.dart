import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentRed,
            secondary: AppColors.accentBlue,
            surface: AppColors.surfaceLight,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.textPrimary,
          ),
          cardTheme: CardThemeData(
            color: AppColors.surfaceLight,
            elevation: AppSizes.cardElevationMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
              ),
              minimumSize: const Size(double.infinity, AppSizes.buttonMinHeight),
              elevation: 4,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryDarker,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.accentBlue),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

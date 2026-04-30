import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/providers/app_settings.dart';

class StoryCard extends StatelessWidget {
  final String text;

  const StoryCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, _) {
        return Card(
          color: AppColors.surfaceLight.withOpacity(0.05),
          elevation: AppSizes.cardElevationMedium,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingLg),
            child: SingleChildScrollView(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: AppFontSizes.bodyLarge * settings.textSizeMultiplier,
                  height: 1.7,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

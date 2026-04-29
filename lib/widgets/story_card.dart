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
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMd,
            vertical: AppSizes.spacingXs,
          ),
          child: Card(
            color: AppColors.surfaceLight,
            elevation: AppSizes.cardElevationMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacingMd),
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: GoogleFonts.nunito(
                    color: AppColors.textPrimary,
                    fontSize: AppFontSizes.storyTextSize * settings.textSizeMultiplier,
                    height: 1.65,
                    letterSpacing: AppLetterSpacing.storyText,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

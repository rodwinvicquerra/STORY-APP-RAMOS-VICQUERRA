import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';

class StoryCard extends StatelessWidget {
  final String text;

  const StoryCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      child: Card(
        color: AppColors.surfaceLight,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                color: AppColors.textLight,
                fontSize: AppFontSizes.storyTextSize,
                height: 1.65,
                letterSpacing: AppLetterSpacing.storyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

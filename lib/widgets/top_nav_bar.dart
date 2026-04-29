import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';

class TopNavBar extends StatelessWidget {
  final VoidCallback? onHomePressed;
  final VoidCallback? onSettingsPressed;
  final String title;

  const TopNavBar({
    super.key,
    this.onHomePressed,
    this.onSettingsPressed,
    this.title = AppStrings.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.appBarHeight,
      decoration: BoxDecoration(
        color: AppColors.primaryDarker.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accentRed.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMd,
            vertical: AppSizes.spacingSm,
          ),
          child: Row(
            children: [
              // Home button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onHomePressed,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.spacingSm),
                    child: const Icon(
                      Icons.home_rounded,
                      color: AppColors.accentBlue,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // Spacer
              const Expanded(child: SizedBox()),

              // Title
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: AppFontSizes.appBarTitleSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Spacer
              const Expanded(child: SizedBox()),

              // Settings button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onSettingsPressed,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.spacingSm),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: AppColors.accentBlue,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

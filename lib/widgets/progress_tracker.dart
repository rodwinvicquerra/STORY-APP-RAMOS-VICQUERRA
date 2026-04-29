import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/models/story_brain.dart';

class ProgressTracker extends StatelessWidget {
  final StoryBrain brain;

  const ProgressTracker({
    super.key,
    required this.brain,
  });

  @override
  Widget build(BuildContext context) {
    final currentScene = brain.getCurrentSceneNumber();
    final totalScenes = brain.getTotalScenes();
    final scenesVisited = brain.getScenesVisited();
    final completionPercentage = brain.getCompletionPercentage();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Scene Progress
          _ProgressItem(
            label: AppStrings.sceneLabel,
            value: '$currentScene/$totalScenes',
            icon: Icons.bookmark_rounded,
          ),
          // Divider
          Container(
            width: 1,
            height: 40,
            color: AppColors.textDimmed.withValues(alpha: 0.3),
          ),
          // Paths Explored
          _ProgressItem(
            label: AppStrings.pathsLabel,
            value: '$scenesVisited/${brain.getTotalPaths()}',
            icon: Icons.fork_right_rounded,
          ),
          // Divider
          Container(
            width: 1,
            height: 40,
            color: AppColors.textDimmed.withValues(alpha: 0.3),
          ),
          // Completion
          _ProgressItem(
            label: AppStrings.completionLabel,
            value: '${completionPercentage.toStringAsFixed(0)}%',
            icon: Icons.percent_rounded,
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProgressItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.smallIconSize,
              color: AppColors.accentRed,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.nunito(
                color: AppColors.textDimmed,
                fontSize: AppFontSizes.progressLabelSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cinzel(
            color: AppColors.accentRed,
            fontSize: AppFontSizes.progressValueSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

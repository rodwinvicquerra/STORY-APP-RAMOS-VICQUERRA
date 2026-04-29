import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/providers/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarker,
        elevation: 0,
        title: Text(
          'SETTINGS',
          style: GoogleFonts.cinzel(
            color: AppColors.accentRed,
            fontSize: AppFontSizes.appBarTitleSize,
            fontWeight: FontWeight.w700,
            letterSpacing: AppLetterSpacing.appBarTitle,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.accentBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppSettings>(
        builder: (context, settings, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Audio Settings Section
                _buildSectionHeader('🔊 Audio Settings'),
                _buildSettingCard(
                  title: 'Music Volume',
                  icon: Icons.music_note_rounded,
                  child: Column(
                    children: [
                      Slider(
                        value: settings.musicVolume,
                        onChanged: (value) {
                          settings.setMusicVolume(value);
                        },
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: AppColors.accentRed,
                        inactiveColor:
                            AppColors.accentRed.withValues(alpha: 0.2),
                        label:
                            '${(settings.musicVolume * 100).toStringAsFixed(0)}%',
                      ),
                      Text(
                        '${(settings.musicVolume * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.nunito(
                          color: AppColors.textDimmed,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSettingCard(
                  title: 'SFX Volume',
                  icon: Icons.volume_up_rounded,
                  child: Column(
                    children: [
                      Slider(
                        value: settings.sfxVolume,
                        onChanged: (value) {
                          settings.setSfxVolume(value);
                        },
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: AppColors.accentRed,
                        inactiveColor:
                            AppColors.accentRed.withValues(alpha: 0.2),
                        label:
                            '${(settings.sfxVolume * 100).toStringAsFixed(0)}%',
                      ),
                      Text(
                        '${(settings.sfxVolume * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.nunito(
                          color: AppColors.textDimmed,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Text Size Settings
                _buildSectionHeader('📝 Text Size'),
                _buildSettingCard(
                  title: 'Text Size Multiplier',
                  icon: Icons.text_fields_rounded,
                  child: Column(
                    children: [
                      Slider(
                        value: settings.textSizeMultiplier,
                        onChanged: (value) {
                          settings.setTextSizeMultiplier(value);
                        },
                        min: 0.8,
                        max: 1.5,
                        divisions: 7,
                        activeColor: AppColors.accentRed,
                        inactiveColor:
                            AppColors.accentRed.withValues(alpha: 0.2),
                        label:
                            '${(settings.textSizeMultiplier * 100).toStringAsFixed(0)}%',
                      ),
                      Text(
                        '${(settings.textSizeMultiplier * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.nunito(
                          color: AppColors.textDimmed,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lorem ipsum dolor sit amet',
                        style: GoogleFonts.nunito(
                          color: AppColors.textLight,
                          fontSize: 14 * settings.textSizeMultiplier,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Animation Settings
                _buildSectionHeader('⚡ Animation Settings'),
                _buildToggleSetting(
                  title: 'Skip Animations',
                  subtitle: 'For faster navigation',
                  icon: Icons.fast_forward_rounded,
                  value: settings.skipAnimations,
                  onChanged: (value) {
                    settings.setSkipAnimations(value);
                  },
                ),
                const SizedBox(height: 8),

                // Playthrough History Section
                _buildSectionHeader('📊 Playthrough History'),
                if (settings.playthroughHistory.isEmpty)
                  _buildSettingCard(
                    title: 'No playthroughs yet',
                    icon: Icons.history_rounded,
                    child: Text(
                      'Start a game to see your playthrough history here.',
                      style: GoogleFonts.nunito(
                        color: AppColors.textDimmed,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      _buildSettingCard(
                        title: 'Total Playthroughs',
                        icon: Icons.games_rounded,
                        child: Text(
                          '${settings.playthroughHistory.length}',
                          style: GoogleFonts.cinzel(
                            color: AppColors.accentRed,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSettingCard(
                        title: 'Unique Endings Found',
                        icon: Icons.emoji_events_rounded,
                        child: Text(
                          '${settings.getUniqueEndings().length}/4',
                          style: GoogleFonts.cinzel(
                            color: AppColors.accentRed,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingMedium,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            settings.clearHistory();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Playthrough history cleared',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.accentRed,
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Clear History'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentRed.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

                // Reset Button
                _buildSectionHeader('🔄 General'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surfaceLight,
                          title: Text(
                            'Reset Settings?',
                            style: GoogleFonts.cinzel(
                              color: AppColors.accentRed,
                            ),
                          ),
                          content: Text(
                            'This will reset all settings to their default values.',
                            style: GoogleFonts.nunito(
                              color: AppColors.textLight,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                settings.resetToDefaults();
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Settings reset to defaults',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: AppColors.accentBlue,
                                  ),
                                );
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: const Text('Reset to Defaults'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingMedium,
        16,
        AppSizes.paddingMedium,
        8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.cinzel(
            color: AppColors.accentRed,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Card(
        color: AppColors.surfaceLight.withValues(alpha: 0.8),
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          side: BorderSide(
            color: AppColors.accentRed.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.accentRed,
                    size: AppSizes.smallIconSize,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      color: AppColors.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      child: Card(
        color: AppColors.surfaceLight.withValues(alpha: 0.8),
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
          side: BorderSide(
            color: AppColors.accentRed.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.accentRed,
                size: AppSizes.smallIconSize,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        color: AppColors.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        color: AppColors.textDimmed,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.accentRed,
                activeTrackColor: AppColors.accentRed.withValues(alpha: 0.3),
                inactiveThumbColor: AppColors.textDimmed,
                inactiveTrackColor:
                    AppColors.textDimmed.withValues(alpha: 0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

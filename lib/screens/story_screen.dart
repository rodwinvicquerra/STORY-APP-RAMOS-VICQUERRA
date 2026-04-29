import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import 'package:missing_flash_drive/providers/app_settings.dart';
import '../models/story_brain.dart';
import '../widgets/choice_button.dart';
import '../widgets/story_card.dart';
import '../widgets/progress_tracker.dart';
import 'ending_screen.dart';
import 'settings_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  final StoryBrain _brain = StoryBrain();
  final AudioPlayer _bgPlayer = AudioPlayer();

  late AnimationController _imageAnimController;
  late Animation<double> _imageFadeAnim;
  
  VideoPlayerController? _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    final settings = context.read<AppSettings>();
    
    _imageAnimController = AnimationController(
      vsync: this,
      duration: settings.skipAnimations 
          ? Duration.zero 
          : AppDurations.imageFadeAnimation,
    );
    _imageFadeAnim = CurvedAnimation(
      parent: _imageAnimController,
      curve: Curves.easeIn,
    );
    _imageAnimController.forward();
    _startBgMusic();
    _initializeVideo();
  }

  Future<void> _startBgMusic() async {
    try {
      final settings = context.read<AppSettings>();
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(settings.musicVolume);
      await _bgPlayer.stop();
      await _bgPlayer.play(AssetSource(AppAssets.bgMusic));
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  Future<void> _initializeVideo() async {
    try {
      final videoPath = _brain.getVideoPath();
      if (videoPath != null && videoPath.isNotEmpty) {
        _videoController = VideoPlayerController.asset(videoPath);
        await _videoController!.initialize();
        await _videoController!.setLooping(true);
        await _videoController!.play();
        if (mounted) {
          setState(() => _videoReady = true);
        }
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      // Fallback to static image if video fails
    }
  }

  Future<void> _disposeVideo() async {
    await _videoController?.dispose();
    _videoController = null;
    _videoReady = false;
  }

  @override
  void dispose() {
    _bgPlayer.dispose();
    _imageAnimController.dispose();
    _disposeVideo();
    super.dispose();
  }

  void _makeChoice(int index) {
    setState(() {
      _brain.nextScene(index);
    });

    // Dispose old video and initialize new one if exists
    _disposeVideo();
    _initializeVideo();

    // Animate image transition
    _imageAnimController.reset();
    _imageAnimController.forward();

    if (_brain.isGameOver()) {
      _handleEnding();
    }
  }

  Future<void> _handleEnding() async {
    final settings = context.read<AppSettings>();
    
    // Play ending sound
    final AudioPlayer sfxPlayer = AudioPlayer();
    final type = _brain.getEndingType();
    try {
      await sfxPlayer.setVolume(settings.sfxVolume);
      if (type == 'good') {
        await sfxPlayer.play(AssetSource(AppAssets.goodEndingSound));
      } else {
        await sfxPlayer.play(AssetSource(AppAssets.badEndingSound));
      }
    } catch (e) {
      debugPrint('Error playing ending sound: $e');
    }

    await Future.delayed(
      settings.skipAnimations 
          ? Duration.zero 
          : AppDurations.endingSoundDelay,
    );

    if (!mounted) return;

    // Save playthrough
    settings.savePlaythrough(
      endingType: type,
      scenesVisited: _brain.getScenesVisited(),
      totalScenes: _brain.getTotalScenes(),
      pathsTaken: _brain.getPathsTaken(),
    );

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => EndingScreen(
          endingType: _brain.getEndingType(),
          endingTitle: _brain.getEndingTitle(),
          endingMessage: _brain.getEndingMessage(),
        ),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: settings.skipAnimations 
            ? Duration.zero 
            : AppDurations.endingTransitionDuration,
      ),
    );

    if (result == 'restart' && mounted) {
      setState(() {
        _brain.restart();
      });
      _disposeVideo();
      _initializeVideo();
      _imageAnimController.reset();
      _imageAnimController.forward();
    }

    sfxPlayer.dispose();
  }

  Color _getSceneAccent() {
    final type = _brain.getEndingType();
    if (type == 'good') return AppColors.endingGood;
    if (type == 'bad') return AppColors.endingBad;
    if (type == 'neutral') return AppColors.endingNeutral;
    if (type == 'weird') return AppColors.endingWeird;
    return AppColors.accentRed;
  }

  @override
  Widget build(BuildContext context) {
    final choices = _brain.getChoices();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= AppSizes.tabletMinWidth;
    final isMobile = screenWidth < AppSizes.tabletMinWidth;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: Text(
          AppStrings.appBarTitle,
          style: GoogleFonts.cinzel(
            color: AppColors.accentRed,
            fontSize: AppFontSizes.appBarTitleSize,
            fontWeight: FontWeight.w700,
            letterSpacing: AppLetterSpacing.appBarTitle,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, color: AppColors.accentBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.accentBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isMobile ? _buildMobileLayout(choices) : _buildDesktopLayout(choices),
      ),
    );
  }

  Widget _buildMobileLayout(List<String> choices) {
    return Column(
      children: [
        // Progress Tracker
        Padding(
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          child: ProgressTracker(brain: _brain),
        ),

        // Scene Image/Video - Mobile
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingMd,
            AppSizes.spacingXs,
            AppSizes.spacingMd,
            AppSizes.spacingMd,
          ),
          child: _buildImageCard(height: 240),
        ),

        // Story Text
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
            child: StoryCard(text: _brain.getStoryText()),
          ),
        ),

        // Choices - Mobile
        Expanded(
          flex: 2,
          child: _buildChoicesList(choices),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(List<String> choices) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      child: Row(
        children: [
          // Left Section - Text Content
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Tracker
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
                  child: ProgressTracker(brain: _brain),
                ),

                // Story Content Card
                Expanded(
                  child: _buildStoryContentCard(choices),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSizes.spacingLg),

          // Right Section - Image
          Expanded(
            flex: 1,
            child: _buildImageCard(height: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContentCard(List<String> choices) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(AppSizes.largeCardBorderRadius),
        border: Border.all(
          color: AppColors.accentRed.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentRed.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Story Text
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacingMd),
              child: SingleChildScrollView(
                child: Consumer<AppSettings>(
                  builder: (context, settings, _) {
                    return Text(
                      _brain.getStoryText(),
                      style: GoogleFonts.nunito(
                        color: AppColors.textLight,
                        fontSize: AppFontSizes.storyTextSize * settings.textSizeMultiplier,
                        height: 1.8,
                        letterSpacing: AppLetterSpacing.storyText,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.accentRed.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Choices
          Expanded(
            flex: 1,
            child: _buildChoicesList(choices),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard({required double? height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.largeCardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentRed.withValues(alpha: 0.25),
            blurRadius: 25,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _imageFadeAnim,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.largeCardBorderRadius),
          child: Container(
            color: AppColors.primaryDarker,
            child: _videoReady && _videoController != null
                ? VideoPlayer(_videoController!)
                : Image.asset(
                    _brain.getImagePath(),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoicesList(List<String> choices) {
    return choices.isEmpty
        ? Center(
            child: Text(
              'Tap the back button to continue...',
              style: GoogleFonts.nunito(
                color: AppColors.textDimmed.withValues(alpha: 0.6),
                fontSize: AppFontSizes.small,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMd,
              vertical: AppSizes.spacingXs,
            ),
            itemCount: choices.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingXs),
              child: ChoiceButton(
                label: choices[i],
                index: i,
                onTap: () => _makeChoice(i),
              ),
            ),
          );
  }
}

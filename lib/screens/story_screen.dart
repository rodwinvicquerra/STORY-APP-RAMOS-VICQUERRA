import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:missing_flash_drive/constants/app_constants.dart';
import '../models/story_brain.dart';
import '../widgets/choice_button.dart';
import '../widgets/story_card.dart';
import '../widgets/progress_tracker.dart';
import 'ending_screen.dart';

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
    _imageAnimController = AnimationController(
      vsync: this,
      duration: AppDurations.imageFadeAnimation,
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
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
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
    // Play ending sound
    final AudioPlayer sfxPlayer = AudioPlayer();
    final type = _brain.getEndingType();
    try {
      if (type == 'good') {
        await sfxPlayer.play(AssetSource(AppAssets.goodEndingSound));
      } else {
        await sfxPlayer.play(AssetSource(AppAssets.badEndingSound));
      }
    } catch (e) {
      debugPrint('Error playing ending sound: $e');
    }

    await Future.delayed(AppDurations.endingSoundDelay);

    if (!mounted) return;

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
        transitionDuration: AppDurations.endingTransitionDuration,
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

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDarker,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Tracker
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: ProgressTracker(brain: _brain),
            ),

            // Scene Image/Video
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingMedium,
                8,
                AppSizes.paddingMedium,
                AppSizes.paddingSmall,
              ),
              child: Card(
                color: AppColors.primaryDarker,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.largeCardBorderRadius),
                  side: BorderSide(
                    color: _getSceneAccent().withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 8,
                child: FadeTransition(
                  opacity: _imageFadeAnim,
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: _videoReady && _videoController != null
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Image.asset(
                              _brain.getImagePath(),
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            // Story Text
            Expanded(
              flex: 4,
              child: StoryCard(text: _brain.getStoryText()),
            ),

            // Choices
            Expanded(
              flex: 3,
              child: choices.isEmpty
                  ? Center(
                      child: Text(
                        'Tap the back button to continue...',
                        style: GoogleFonts.nunito(
                          color: AppColors.textDimmed.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: choices.length,
                      itemBuilder: (context, i) => ChoiceButton(
                        label: choices[i],
                        index: i,
                        onTap: () => _makeChoice(i),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

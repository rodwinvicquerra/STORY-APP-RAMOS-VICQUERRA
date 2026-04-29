import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/story_brain.dart';
import '../widgets/choice_button.dart';
import '../widgets/story_card.dart';
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

  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _imageFadeAnim = CurvedAnimation(
      parent: _imageAnimController,
      curve: Curves.easeIn,
    );
    _imageAnimController.forward();
    _startBgMusic();
  }

  Future<void> _startBgMusic() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.play(AssetSource('audio/bg_music.mp3'));
  }

  @override
  void dispose() {
    _bgPlayer.dispose();
    _imageAnimController.dispose();
    super.dispose();
  }

  void _makeChoice(int index) {
    setState(() {
      _brain.nextScene(index);
    });

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
    if (type == 'good') {
      await sfxPlayer.play(AssetSource('audio/good_ending.mp3'));
    } else {
      await sfxPlayer.play(AssetSource('audio/bad_ending.mp3'));
    }

    await Future.delayed(const Duration(milliseconds: 800));

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
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );

    if (result == 'restart' && mounted) {
      setState(() {
        _brain.restart();
      });
      _imageAnimController.reset();
      _imageAnimController.forward();
    }

    sfxPlayer.dispose();
  }

  Color _getSceneAccent() {
    final type = _brain.getEndingType();
    if (type == 'good') return const Color(0xFF4CAF50);
    if (type == 'bad') return const Color(0xFFF44336);
    if (type == 'neutral') return const Color(0xFFFFC107);
    if (type == 'weird') return const Color(0xFF9C27B0);
    return const Color(0xFFE94560);
  }

  @override
  Widget build(BuildContext context) {
    final choices = _brain.getChoices();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F23),
        elevation: 0,
        title: Text(
          'THE MISSING FLASH DRIVE',
          style: GoogleFonts.cinzel(
            color: const Color(0xFFE94560),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, color: Color(0xFF90CAF9)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scene Image
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Card(
                color: const Color(0xFF0F0F23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
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
                    height: 200,
                    width: double.infinity,
                    child: FractionallySizedBox(
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
                          color: const Color(0xFF546E7A),
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

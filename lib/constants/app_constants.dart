import 'package:flutter/material.dart';

// Colors
class AppColors {
  // Primary colors
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color primaryDarker = Color(0xFF0F0F23);
  static const Color accentRed = Color(0xFFE94560);
  static const Color accentBlue = Color(0xFF90CAF9);
  static const Color surfaceLight = Color(0xFF16213E);
  static const Color surfaceMedium = Color(0xFF0F3460);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textDimmed = Color(0xFF90CAF9);
  static const Color splashBg = Color(0xFF12122A);

  // Ending colors
  static const Color endingGood = Color(0xFF4CAF50);
  static const Color endingGoodLight = Color(0xFF81C784);
  static const Color endingGoodBg1 = Color(0xFF0A2A0F);
  static const Color endingGoodBg2 = Color(0xFF1B5E20);

  static const Color endingBad = Color(0xFFF44336);
  static const Color endingBadLight = Color(0xFFEF9A9A);
  static const Color endingBadBg1 = Color(0xFF2A0A0A);
  static const Color endingBadBg2 = Color(0xFF7F0000);

  static const Color endingNeutral = Color(0xFFFFC107);
  static const Color endingNeutralLight = Color(0xFFFFD54F);
  static const Color endingNeutralBg1 = Color(0xFF2A2200);
  static const Color endingNeutralBg2 = Color(0xFF827717);

  static const Color endingWeird = Color(0xFFCE93D8);
  static const Color endingWeirdBg1 = Color(0xFF1A0A2A);
  static const Color endingWeirdBg2 = Color(0xFF4A148C);
}

// Animation Durations
class AppDurations {
  static const Duration imageFadeAnimation = Duration(milliseconds: 500);
  static const Duration splashFadeAnimation = Duration(milliseconds: 1200);
  static const Duration splashSlideAnimation = Duration(milliseconds: 900);
  static const Duration splashPulseAnimation = Duration(milliseconds: 1000);
  static const Duration splashDelayBeforeStart = Duration(milliseconds: 300);
  static const Duration buttonPressAnimation = Duration(milliseconds: 120);
  static const Duration endingFadeAnimation = Duration(milliseconds: 800);
  static const Duration endingScaleAnimation = Duration(milliseconds: 600);
  static const Duration endingPulseAnimation = Duration(milliseconds: 900);
  static const Duration endingTransitionDuration = Duration(milliseconds: 700);
  static const Duration endingSoundDelay = Duration(milliseconds: 800);
  static const Duration videoFadeAnimation = Duration(milliseconds: 400);
}

// Asset Paths
class AppAssets {
  // Images
  static const String scene0Image = 'assets/images/scene_0.png';
  static const String scene1Image = 'assets/images/scene_1.png';
  static const String scene2Image = 'assets/images/scene_2.png';
  static const String scene3Image = 'assets/images/scene_3.png';
  static const String scene4Image = 'assets/images/scene_4.png';
  static const String scene5Image = 'assets/images/scene_5.png';
  static const String scene6Image = 'assets/images/scene_6.png';
  static const String scene7Image = 'assets/images/scene_7.png';
  static const String scene8Image = 'assets/images/scene_8.png';
  static const String splashBgImage = 'assets/images/splash_bg.png';

  // Audio
  static const String bgMusic = 'audio/bg_music.mp3';
  static const String goodEndingSound = 'audio/good_ending.mp3';
  static const String badEndingSound = 'audio/bad_ending.mp3';

  // Videos (optional - add when available)
  static const String scene0Video = 'assets/videos/scene_0.mp4';
  static const String scene1Video = 'assets/videos/scene_1.mp4';
  static const String scene2Video = 'assets/videos/scene_2.mp4';
  static const String scene3Video = 'assets/videos/scene_3.mp4';
}

// Text Strings
class AppStrings {
  // App title and general
  static const String appTitle = 'The Missing Flash Drive';
  static const String storyTitle = 'THE MISSING FLASH DRIVE';
  static const String subtitle = 'A Choose Your Own Adventure Story';
  static const String appBarTitle = 'THE MISSING FLASH DRIVE';

  // Scene 0
  static const String scene0Text =
      '📱 Oh no! It\'s 4:30 PM and your final IT project is due at 5:00 PM.\n\n'
      'You reach into your bag... YOUR FLASH DRIVE IS GONE! 😱\n\n'
      'You start to panic. You had it this morning but now it\'s nowhere to be found.\n\n'
      'Where will you look first?';
  static const String scene0Choice1 = '🏫 Go to the Library';
  static const String scene0Choice2 = '🍜 Go to the Cafeteria';

  // Scene 1
  static const String scene1Text =
      '📚 You rush into the quiet library. The librarian looks up and whispers,\n'
      '"Looking for something? I saw a student near the dark hallway earlier..."\n\n'
      'You notice the hallway she pointed to — it\'s dark and eerie.\n'
      'But you also see the table where you studied yesterday morning!\n\n'
      'What do you do?';
  static const String scene1Choice1 = '🔦 Walk into the dark hallway';
  static const String scene1Choice2 = '🪑 Check the table where I sat';

  // Scene 2
  static const String scene2Text =
      '🍽️ The cafeteria is loud and packed with students.\n\n'
      'You spot your classmate MARK sitting alone, eating pancit canton.\n'
      'He was your project partner yesterday — he might know something!\n\n'
      'But you\'re also really hungry and the arroz caldo smells amazing...\n\n'
      'What will you do?';
  static const String scene2Choice1 = '🙋 Ask Mark for help';
  static const String scene2Choice2 = '🍚 Ignore Mark and buy a snack';

  // Scene 3
  static const String scene3Text =
      '😰 The hallway is dark and cold. Your footsteps echo with every step.\n\n'
      'Suddenly, at the end of the hallway, you see a GLOWING PORTAL!\n'
      'It pulses with blue and purple light, humming softly.\n\n'
      'A whisper in the air says: "Your destiny lies beyond..."\n\n'
      'Do you dare enter? Or run back to safety?';
  static const String scene3Choice1 = '✨ Enter the glowing portal';
  static const String scene3Choice2 = '🏃 Run back to safety';

  // Ending 4 (Good)
  static const String scene4Title = 'Submitted On Time!';
  static const String scene4Message =
      'You found your flash drive under the library table and submitted your project with 3 minutes to spare. Your hard work paid off!';

  // Ending 5 (Good)
  static const String scene5Title = 'Mark Saved the Day!';
  static const String scene5Message =
      'Your classmate Mark had accidentally taken your flash drive. He returned it and you submitted your project just in time!';

  // Ending 6 (Bad)
  static const String scene6Title = 'You Missed the Deadline!';
  static const String scene6Message =
      'You wasted too much time buying snacks and missed the 5:00 PM deadline. The project was not accepted.';

  // Ending 7 (Weird)
  static const String scene7Title = 'Transported to Another Dimension!';
  static const String scene7Message =
      'You stepped through the portal and got transported to a fantasy kingdom. You became a warrior... but failed IT class.';

  // Ending 8 (Neutral)
  static const String scene8Title = 'Lost Forever...';
  static const String scene8Message =
      'You escaped the portal but never found your flash drive. You\'ll have to retake the IT subject next semester.';

  // Progress labels
  static const String sceneLabel = 'Scene';
  static const String pathsLabel = 'Paths';
  static const String completionLabel = 'Completion';
}

// Sizing and Spacing
class AppSizes {
  static const double buttonBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double largeCardBorderRadius = 18.0;
  static const double appBarHeight = 56.0;
  static const double iconSize = 48.0;
  static const double smallIconSize = 24.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double cardElevation = 6.0;
  static const double usbIconSize = 90.0;
  static const double endingIconSize = 80.0;
}

// Progress Tracking
class ProgressConfig {
  static const int totalScenes = 9;
  static const int totalPaths = 8; // Unique paths in the story tree
  static const double completionPercentagePerScene = 100.0 / totalScenes;
}

// Letter Spacing
class AppLetterSpacing {
  static const double appBarTitle = 2.0;
  static const double splashTitle = 6.0;
  static const double splashSubtitle = 4.0;
  static const double storyText = 0.2;
}

// Font Sizes
class AppFontSizes {
  static const double appBarTitleSize = 14.0;
  static const double splashTitleSmall = 26.0;
  static const double splashTitleLarge = 34.0;
  static const double splashSubtitleSize = 16.0;
  static const double storyTextSize = 15.5;
  static const double buttonTextSize = 14.0;
  static const double progressLabelSize = 12.0;
  static const double progressValueSize = 18.0;
}

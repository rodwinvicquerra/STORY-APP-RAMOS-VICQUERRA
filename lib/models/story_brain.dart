import 'package:missing_flash_drive/constants/app_constants.dart';
import 'scene.dart';

class StoryBrain {
  int _currentScene = 0;
  final Set<int> _visitedScenes = {0}; // Track visited scenes for completion

  static final List<Scene> _scenes = [
    // Scene 0 — Start (Decision Point 1)
    Scene(
      storyText: AppStrings.scene0Text,
      imagePath: AppAssets.scene0Image,
      choices: [AppStrings.scene0Choice1, AppStrings.scene0Choice2],
      nextScenes: [1, 2],
    ),

    // Scene 1 — Library (Decision Point 2)
    Scene(
      storyText: AppStrings.scene1Text,
      imagePath: AppAssets.scene1Image,
      choices: [AppStrings.scene1Choice1, AppStrings.scene1Choice2],
      nextScenes: [3, 4],
    ),

    // Scene 2 — Cafeteria (Decision Point 3)
    Scene(
      storyText: AppStrings.scene2Text,
      imagePath: AppAssets.scene2Image,
      choices: [AppStrings.scene2Choice1, AppStrings.scene2Choice2],
      nextScenes: [5, 6],
    ),

    // Scene 3 — Dark Hallway (Decision Point 4)
    Scene(
      storyText: AppStrings.scene3Text,
      imagePath: AppAssets.scene3Image,
      choices: [AppStrings.scene3Choice1, AppStrings.scene3Choice2],
      nextScenes: [7, 8],
    ),

    // Scene 4 — Found under table (Ending: Good 1)
    Scene(
      storyText:
          '🎉 You crawl under the table and — THERE IT IS!\n\n'
          'Your flash drive was stuck between the chair leg and the floor!\n\n'
          'You grab it, shove it in your laptop, and SPRINT to your professor\'s room.\n\n'
          '"Submitted with 3 minutes to spare!" your professor smiles.\n\n'
          'You did it! You saved your grade! 🏆',
      imagePath: AppAssets.scene4Image,
      isEnding: true,
      endingType: 'good',
      endingTitle: AppStrings.scene4Title,
      endingMessage: AppStrings.scene4Message,
    ),

    // Scene 5 — Mark returns it (Ending: Good 2)
    Scene(
      storyText:
          '😅 Mark looks embarrassed.\n\n'
          '"Oh... about that," he says, reaching into his bag.\n'
          '"I accidentally grabbed it yesterday when we were packing up. Sorry!"\n\n'
          'He hands you the flash drive.\n\n'
          'You forgive him immediately, plug it into your laptop, and submit with\n'
          '5 minutes to spare!\n\n'
          '"We\'re still best friends," you tell him. 🤝',
      imagePath: AppAssets.scene5Image,
      isEnding: true,
      endingType: 'good',
      endingTitle: AppStrings.scene5Title,
      endingMessage: AppStrings.scene5Message,
    ),

    // Scene 6 — Wasted time (Ending: Bad)
    Scene(
      storyText:
          '🍚 The arroz caldo is warm and delicious...\n\n'
          'You lose track of time eating and chatting with strangers.\n\n'
          'You check your phone — 5:01 PM. 😱\n\n'
          '"DEADLINE MISSED!" flashes on the school portal.\n\n'
          'Your professor shakes his head sadly.\n'
          '"You\'ll have to retake the subject next semester."\n\n'
          'The snack was NOT worth it. 💀',
      imagePath: AppAssets.scene6Image,
      isEnding: true,
      endingType: 'bad',
      endingTitle: AppStrings.scene6Title,
      endingMessage: AppStrings.scene6Message,
    ),

    // Scene 7 — Enter portal (Ending: Weird/Bad)
    Scene(
      storyText:
          '⚡ You take a deep breath and STEP INTO THE PORTAL!\n\n'
          'FLASH! You\'re now wearing armor in a magical kingdom.\n'
          'A fairy appears: "Welcome, Chosen One! You must defeat the Dragon of Deadlines!"\n\n'
          'You look at your hands — you\'re holding a sword, not a laptop.\n\n'
          '"Wait, what about my IT project?!"\n\n'
          'The fairy shrugs. "What\'s an IT project?"\n\n'
          'You failed IT class but became a legendary warrior. ⚔️',
      imagePath: AppAssets.scene7Image,
      isEnding: true,
      endingType: 'weird',
      endingTitle: AppStrings.scene7Title,
      endingMessage: AppStrings.scene7Message,
    ),

    // Scene 8 — Run away (Ending: Neutral)
    Scene(
      storyText:
          '😤 Nope. Portals are NOT part of your plans today.\n\n'
          'You sprint back to the library entrance, heart pounding.\n\n'
          'You search everywhere — every classroom, every hallway — but the flash drive is gone.\n\n'
          'With no other option, you email your professor:\n'
          '"Sir, I lost my flash drive. I\'m very sorry."\n\n'
          'He replies: "Okay. Retake the subject next term."\n\n'
          'At least you\'re still in this dimension. 🤷',
      imagePath: AppAssets.scene8Image,
      isEnding: true,
      endingType: 'neutral',
      endingTitle: AppStrings.scene8Title,
      endingMessage: AppStrings.scene8Message,
    ),
  ];

  // Public methods
  String getStoryText() => _scenes[_currentScene].storyText;

  List<String> getChoices() => _scenes[_currentScene].choices;

  String getImagePath() => _scenes[_currentScene].imagePath;

  String? getVideoPath() => _scenes[_currentScene].videoPath;

  bool isGameOver() => _scenes[_currentScene].isEnding;

  String getEndingType() => _scenes[_currentScene].endingType;

  String getEndingTitle() => _scenes[_currentScene].endingTitle;

  String getEndingMessage() => _scenes[_currentScene].endingMessage;

  int getCurrentSceneIndex() => _currentScene;

  /// Get current scene number (1-based for display)
  int getCurrentSceneNumber() => _currentScene + 1;

  /// Get total number of unique scenes
  int getTotalScenes() => _scenes.length;

  /// Get total number of branching paths that can be taken
  int getTotalPaths() => ProgressConfig.totalPaths;

  /// Get completion percentage based on scenes visited
  double getCompletionPercentage() {
    return (_visitedScenes.length / _scenes.length) * 100;
  }

  /// Get number of scenes visited
  int getScenesVisited() => _visitedScenes.length;

  void nextScene(int choiceIndex) {
    final choices = _scenes[_currentScene].nextScenes;
    if (choiceIndex < choices.length) {
      _currentScene = choices[choiceIndex];
      _visitedScenes.add(_currentScene);
    }
  }

  void restart() {
    _currentScene = 0;
    _visitedScenes.clear();
    _visitedScenes.add(0);
  }
}

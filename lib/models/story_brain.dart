import 'package:missing_flash_drive/constants/app_constants.dart';
import 'scene.dart';

class StoryBrain {
  int _currentScene = 0;
  final Set<int> _visitedScenes = {0}; // Track visited scenes for completion
  final List<int> _pathsTaken = [0]; // Track path decisions

  static final List<Scene> _scenes = [
    // Scene 0 — Start (Decision Point 1)
    Scene(
      storyText: AppStrings.scene0Text,
      imagePath: AppAssets.scene0Image,
      choices: [AppStrings.scene0Choice1, AppStrings.scene0Choice2, 'Go to the Classroom'],
      nextScenes: [1, 2, 3],
    ),

    // Scene 1 — Library (Decision Point 2)
    Scene(
      storyText: AppStrings.scene1Text,
      imagePath: AppAssets.scene1Image,
      choices: [AppStrings.scene1Choice1, 'Ask the librarian for help', AppStrings.scene1Choice2],
      nextScenes: [9, 4, 5],
    ),

    // Scene 2 — Cafeteria (Decision Point 3)
    Scene(
      storyText: AppStrings.scene2Text,
      imagePath: AppAssets.scene2Image,
      choices: [AppStrings.scene2Choice1, 'Look around the cafeteria', AppStrings.scene2Choice2],
      nextScenes: [7, 9, 10],
    ),

    // Scene 3 — Classroom (NEW)
    Scene(
      storyText:
          'You head back to your classroom. It\'s nearly empty now.\n\n'
          'You check your desk, but it\'s not there. The janitor is cleaning nearby.\n\n'
          'What will you do?',
      imagePath: AppAssets.scene3Image,
      choices: ['Check your locker', 'Ask the janitor', 'Search the trash bins'],
      nextScenes: [10, 4, 11],
    ),

    // Scene 4 — Librarian (NEW)
    Scene(
      storyText:
          'The librarian smiles kindly. "Lost something? Let me check the lost and found."\n\n'
          'She opens a drawer and shows you several items.\n\n'
          'But time is running out... 20 minutes left!',
      imagePath: AppAssets.scene4Image,
      choices: ['Search thoroughly through items', 'Give up and try another location'],
      nextScenes: [9, 11],
    ),

    // Scene 5 — Dark Hallway
    Scene(
      storyText: AppStrings.scene3Text,
      imagePath: AppAssets.scene3Image,
      choices: [AppStrings.scene3Choice1, AppStrings.scene3Choice2, 'Look around carefully'],
      nextScenes: [12, 13, 11],
    ),

    // Scene 6 — Portal World (EXPANDED)
    Scene(
      storyText:
          'You step through the portal and find yourself in a strange realm.\n\n'
          'Glowing creatures surround you. One speaks: "To return, you must solve our riddle."\n\n'
          'But your flash drive is still missing...',
      imagePath: AppAssets.scene6Image,
      choices: ['Try to solve the riddle', 'Fight your way through'],
      nextScenes: [12, 13],
    ),

    // Scene 7 — Mark Confession (EXPANDED)
    Scene(
      storyText: AppStrings.scene2Text +
          '\n\nMark waves at you. "Hey! I was looking for you!"\n\n'
          'He reaches into his bag...',
      imagePath: AppAssets.scene5Image,
      choices: ['Wait eagerly', 'Ask him directly'],
      nextScenes: [14, 14],
    ),

    // Scene 8 — Time Pressure (NEW)
    Scene(
      storyText:
          'You check your phone. Only 5 minutes left until the deadline!\n\n'
          'Your heart is pounding. You need to find it NOW.',
      imagePath: AppAssets.scene8Image,
      choices: ['Sprint to the lab to submit something', 'Make one last desperate search'],
      nextScenes: [11, 11],
    ),

    // Scene 9 — Found under table (Ending: Good 1)
    Scene(
      storyText:
          'You crawl under the table and there it is!\n\n'
          'Your flash drive was stuck between the chair leg and the floor!\n\n'
          'You grab it, rush to your laptop, and submit your project with 3 minutes to spare.\n\n'
          'Success!',
      imagePath: AppAssets.scene4Image,
      isEnding: true,
      endingType: 'good',
      endingTitle: AppStrings.scene4Title,
      endingMessage: AppStrings.scene4Message,
    ),

    // Scene 10 — Found in classroom (NEW Good Ending)
    Scene(
      storyText:
          'You find it in the lost and found near the classroom office!\n\n'
          'A classmate had turned it in this morning.\n\n'
          'You dash to the lab and submit with 8 minutes to spare!\n\n'
          'What a relief!',
      imagePath: AppAssets.scene4Image,
      isEnding: true,
      endingType: 'good',
      endingTitle: 'Found It!',
      endingMessage: 'You recovered your flash drive and submitted on time.',
    ),

    // Scene 11 — Wasted time (Ending: Bad)
    Scene(
      storyText:
          'You spend too much time searching. When you finally check your phone:\n\n'
          '5:01 PM. The deadline has passed.\n\n'
          '"DEADLINE MISSED!" flashes on the school portal.\n\n'
          'Your professor replies to your email: "You\'ll have to retake the subject next semester."\n\n'
          'This won\'t end well...',
      imagePath: AppAssets.scene6Image,
      isEnding: true,
      endingType: 'bad',
      endingTitle: AppStrings.scene6Title,
      endingMessage: AppStrings.scene6Message,
    ),

    // Scene 12 — Portal trap (Ending: Weird)
    Scene(
      storyText:
          'You step into the portal and find yourself trapped in a magical realm!\n\n'
          'The creatures transform you into a legendary warrior.\n\n'
          'You\'re powerful here, but you failed IT class back home...\n\n'
          'Was it worth it?',
      imagePath: AppAssets.scene7Image,
      isEnding: true,
      endingType: 'weird',
      endingTitle: AppStrings.scene7Title,
      endingMessage: AppStrings.scene7Message,
    ),

    // Scene 13 — Escape the portal (Ending: Neutral)
    Scene(
      storyText:
          'You escape the portal and run back to the school.\n\n'
          'But you never found your flash drive.\n\n'
          'Your professor is understanding: "Next semester. You can retake it."\n\n'
          'At least you\'re back in the real world...',
      imagePath: AppAssets.scene8Image,
      isEnding: true,
      endingType: 'neutral',
      endingTitle: AppStrings.scene8Title,
      endingMessage: AppStrings.scene8Message,
    ),

    // Scene 14 — Mark saves the day (Ending: Good 2)
    Scene(
      storyText:
          'Mark pulls out your flash drive from his bag.\n\n'
          '"I\'m so sorry! I accidentally grabbed it when we were packing up yesterday."\n\n'
          'You forgive him immediately and sprint to the lab.\n\n'
          'You submit with 5 minutes to spare!\n\n'
          '"Thanks, buddy!" you tell him.',
      imagePath: AppAssets.scene5Image,
      isEnding: true,
      endingType: 'good',
      endingTitle: AppStrings.scene5Title,
      endingMessage: AppStrings.scene5Message,
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

  /// Get the paths taken during this playthrough
  List<int> getPathsTaken() => _pathsTaken;

  void nextScene(int choiceIndex) {
    final choices = _scenes[_currentScene].nextScenes;
    if (choiceIndex < choices.length) {
      _currentScene = choices[choiceIndex];
      _visitedScenes.add(_currentScene);
      _pathsTaken.add(choiceIndex);
    }
  }

  void restart() {
    _currentScene = 0;
    _visitedScenes.clear();
    _visitedScenes.add(0);
    _pathsTaken.clear();
    _pathsTaken.add(0);
  }
}

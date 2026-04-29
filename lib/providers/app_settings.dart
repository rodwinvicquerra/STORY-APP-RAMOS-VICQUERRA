import 'package:flutter/foundation.dart';

class AppSettings extends ChangeNotifier {
  // Animation settings
  bool _skipAnimations = false;
  
  // Audio settings (0.0 to 1.0)
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  
  // Text size multiplier (0.8 to 1.5)
  double _textSizeMultiplier = 1.0;
  
  // Playthrough history
  final List<Map<String, dynamic>> _playthroughHistory = [];

  // Getters
  bool get skipAnimations => _skipAnimations;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  double get textSizeMultiplier => _textSizeMultiplier;
  List<Map<String, dynamic>> get playthroughHistory => _playthroughHistory;

  // Setters with notification
  void setSkipAnimations(bool value) {
    if (_skipAnimations != value) {
      _skipAnimations = value;
      notifyListeners();
    }
  }

  void setMusicVolume(double value) {
    final clampedValue = value.clamp(0.0, 1.0);
    if (_musicVolume != clampedValue) {
      _musicVolume = clampedValue;
      notifyListeners();
    }
  }

  void setSfxVolume(double value) {
    final clampedValue = value.clamp(0.0, 1.0);
    if (_sfxVolume != clampedValue) {
      _sfxVolume = clampedValue;
      notifyListeners();
    }
  }

  void setTextSizeMultiplier(double value) {
    final clampedValue = value.clamp(0.8, 1.5);
    if (_textSizeMultiplier != clampedValue) {
      _textSizeMultiplier = clampedValue;
      notifyListeners();
    }
  }

  /// Save a playthrough with the ending type and scenes visited
  void savePlaythrough({
    required String endingType,
    required int scenesVisited,
    required int totalScenes,
    required List<int> pathsTaken,
  }) {
    _playthroughHistory.add({
      'endingType': endingType,
      'scenesVisited': scenesVisited,
      'totalScenes': totalScenes,
      'pathsTaken': pathsTaken,
      'timestamp': DateTime.now(),
      'completionPercentage': (scenesVisited / totalScenes) * 100,
    });
    notifyListeners();
  }

  /// Get unique ending types from history
  List<String> getUniqueEndings() {
    final endings = <String>{};
    for (var playthrough in _playthroughHistory) {
      endings.add(playthrough['endingType'] as String);
    }
    return endings.toList();
  }

  /// Clear playthrough history
  void clearHistory() {
    _playthroughHistory.clear();
    notifyListeners();
  }

  /// Reset all settings to default
  void resetToDefaults() {
    _skipAnimations = false;
    _musicVolume = 0.7;
    _sfxVolume = 0.8;
    _textSizeMultiplier = 1.0;
    notifyListeners();
  }
}

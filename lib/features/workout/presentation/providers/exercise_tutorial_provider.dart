import 'dart:async';
import 'package:flutter/material.dart';

class ExerciseTutorialProvider extends ChangeNotifier {
  bool _isPlaying = false;
  double _playbackProgress = 0.35;
  final int _totalSeconds = 120; // 2 min video duration default
  bool _isMuted = false;
  Timer? _playbackTimer;

  bool get isPlaying => _isPlaying;
  double get playbackProgress => _playbackProgress;
  int get totalSeconds => _totalSeconds;
  bool get isMuted => _isMuted;

  int get currentSeconds => (_totalSeconds * _playbackProgress).round();

  String get formattedCurrentTime {
    final cur = currentSeconds;
    final mins = (cur ~/ 60).toString().padLeft(2, '0');
    final secs = (cur % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  String get formattedTotalTime {
    final mins = (_totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void play() {
    _isPlaying = true;
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_playbackProgress < 1.0) {
        _playbackProgress += 0.5 / _totalSeconds;
        if (_playbackProgress > 1.0) _playbackProgress = 1.0;
        notifyListeners();
      } else {
        pause();
      }
    });
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _playbackTimer?.cancel();
    _playbackTimer = null;
    notifyListeners();
  }

  void seek(double progress) {
    _playbackProgress = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  void restart() {
    _playbackProgress = 0.0;
    play();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}

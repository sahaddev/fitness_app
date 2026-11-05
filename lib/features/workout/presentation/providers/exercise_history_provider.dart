import 'package:flutter/material.dart';

class HistorySetLog {
  final int set;
  final String reps;
  final String kg;
  final String rep;
  final int volume;

  HistorySetLog({
    required this.set,
    required this.reps,
    required this.kg,
    required this.rep,
    required this.volume,
  });
}

class HistorySessionLog {
  final String date;
  final List<HistorySetLog> sets;
  final int totalVolume;

  HistorySessionLog({
    required this.date,
    required this.sets,
    required this.totalVolume,
  });
}

class ExerciseHistoryProvider extends ChangeNotifier {
  final Map<String, List<HistorySessionLog>> _historyLogs = {
    'Seated upperback row': [
      HistorySessionLog(
        date: '26-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '5', kg: '25', rep: '5', volume: 125),
          HistorySetLog(set: 2, reps: '5', kg: '25', rep: '5', volume: 125),
          HistorySetLog(set: 3, reps: '5', kg: '25', rep: '5', volume: 125),
        ],
        totalVolume: 375,
      ),
      HistorySessionLog(
        date: '21-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '8', kg: '52.5', rep: '8', volume: 420),
          HistorySetLog(set: 2, reps: '6', kg: '52.5', rep: '6', volume: 315),
          HistorySetLog(set: 3, reps: '4', kg: '52.5', rep: '4', volume: 210),
        ],
        totalVolume: 945,
      ),
      HistorySessionLog(
        date: '14-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '10', kg: '45', rep: '10', volume: 450),
          HistorySetLog(set: 2, reps: '8', kg: '45', rep: '8', volume: 360),
          HistorySetLog(set: 3, reps: '8', kg: '45', rep: '8', volume: 360),
        ],
        totalVolume: 1170,
      ),
    ],
    'Tricep pushdown': [
      HistorySessionLog(
        date: '26-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '12', kg: '20', rep: '12', volume: 240),
          HistorySetLog(set: 2, reps: '10', kg: '20', rep: '10', volume: 200),
          HistorySetLog(set: 3, reps: '10', kg: '20', rep: '10', volume: 200),
        ],
        totalVolume: 640,
      ),
      HistorySessionLog(
        date: '21-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '12', kg: '17.5', rep: '12', volume: 210),
          HistorySetLog(set: 2, reps: '12', kg: '17.5', rep: '12', volume: 210),
          HistorySetLog(set: 3, reps: '10', kg: '17.5', rep: '10', volume: 175),
        ],
        totalVolume: 595,
      ),
    ],
    'Overall Progress': [
      HistorySessionLog(
        date: '26-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '8', kg: '60', rep: '8', volume: 480),
          HistorySetLog(set: 2, reps: '8', kg: '60', rep: '8', volume: 480),
          HistorySetLog(set: 3, reps: '6', kg: '65', rep: '6', volume: 390),
        ],
        totalVolume: 1350,
      ),
      HistorySessionLog(
        date: '21-10-2026',
        sets: [
          HistorySetLog(set: 1, reps: '10', kg: '50', rep: '10', volume: 500),
          HistorySetLog(set: 2, reps: '10', kg: '50', rep: '10', volume: 500),
          HistorySetLog(set: 3, reps: '8', kg: '55', rep: '8', volume: 440),
        ],
        totalVolume: 1440,
      ),
    ],
  };

  List<HistorySessionLog> getLogsForExercise(String exerciseName) {
    if (_historyLogs.containsKey(exerciseName)) {
      return List.unmodifiable(_historyLogs[exerciseName]!);
    }
    // Return overall or generic logs if specific exercise has none yet
    return _historyLogs['Overall Progress'] ?? [];
  }

  void addSessionLog(String exerciseName, HistorySessionLog log) {
    if (!_historyLogs.containsKey(exerciseName)) {
      _historyLogs[exerciseName] = [];
    }
    _historyLogs[exerciseName]!.insert(0, log);
    notifyListeners();
  }

  double getPersonalBestWeight(String exerciseName) {
    final logs = getLogsForExercise(exerciseName);
    double maxWeight = 0.0;
    for (final log in logs) {
      for (final set in log.sets) {
        final weight = double.tryParse(set.kg) ?? 0.0;
        if (weight > maxWeight) maxWeight = weight;
      }
    }
    return maxWeight;
  }

  int getPersonalBestVolume(String exerciseName) {
    final logs = getLogsForExercise(exerciseName);
    int maxVol = 0;
    for (final log in logs) {
      if (log.totalVolume > maxVol) maxVol = log.totalVolume;
    }
    return maxVol;
  }
}


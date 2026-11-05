import 'package:flutter/material.dart';

class SetData {
  final int setNumber;
  final String targetReps;
  String kg;
  String rep;
  bool isCompleted;

  SetData({
    required this.setNumber,
    required this.targetReps,
    required this.kg,
    required this.rep,
    this.isCompleted = false,
  });

  SetData copyWith({
    int? setNumber,
    String? targetReps,
    String? kg,
    String? rep,
    bool? isCompleted,
  }) {
    return SetData(
      setNumber: setNumber ?? this.setNumber,
      targetReps: targetReps ?? this.targetReps,
      kg: kg ?? this.kg,
      rep: rep ?? this.rep,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get volume {
    final weight = double.tryParse(kg) ?? 0.0;
    final reps = double.tryParse(rep) ?? 0.0;
    return weight * reps;
  }
}

class ExerciseItem {
  final String id;
  final String name;
  final String targetReps;
  final String tutorialInstruction;
  final String? muscleGroup;
  final String? equipment;
  final String? videoUrl;
  final List<SetData> sets;

  ExerciseItem({
    String? id,
    required this.name,
    required this.targetReps,
    required this.tutorialInstruction,
    this.muscleGroup,
    this.equipment,
    this.videoUrl,
    required this.sets,
  }) : id = id ?? name.toLowerCase().replaceAll(' ', '_');

  ExerciseItem copyWith({
    String? id,
    String? name,
    String? targetReps,
    String? tutorialInstruction,
    String? muscleGroup,
    String? equipment,
    String? videoUrl,
    List<SetData>? sets,
  }) {
    return ExerciseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      targetReps: targetReps ?? this.targetReps,
      tutorialInstruction: tutorialInstruction ?? this.tutorialInstruction,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      videoUrl: videoUrl ?? this.videoUrl,
      sets: sets ?? this.sets.map((s) => s.copyWith()).toList(),
    );
  }

  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + set.volume);
  }

  int get completedSetsCount {
    return sets.where((s) => s.isCompleted).length;
  }
}

class WorkoutDay {
  final String id;
  final String title;
  final String subtitle;
  final String number;
  final List<ExerciseItem> exercises;

  WorkoutDay({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.number,
    required this.exercises,
  });

  WorkoutDay copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? number,
    List<ExerciseItem>? exercises,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      number: number ?? this.number,
      exercises: exercises ?? this.exercises.map((e) => e.copyWith()).toList(),
    );
  }

  double get totalVolume {
    return exercises.fold(0.0, (sum, exercise) => sum + exercise.totalVolume);
  }

  int get completedSetsCount {
    return exercises.fold(0, (sum, exercise) => sum + exercise.completedSetsCount);
  }

  int get totalSetsCount {
    return exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);
  }

  bool get isCompleted {
    return totalSetsCount > 0 && completedSetsCount == totalSetsCount;
  }
}

class WorkoutProvider extends ChangeNotifier {
  final List<WorkoutDay> _days = [
    WorkoutDay(
      id: 'day_1',
      title: 'DAY 1',
      subtitle: 'Upper Body Push & Pull',
      number: '1',
      exercises: [
        ExerciseItem(
          name: 'Seated upperback row',
          targetReps: '8-10',
          muscleGroup: 'Back',
          equipment: 'Cable',
          tutorialInstruction: 'Use the long bar lat pulldown attachment',
          sets: [
            SetData(setNumber: 1, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
          ],
        ),
        ExerciseItem(
          name: 'Tricep pushdown',
          targetReps: '10-12',
          muscleGroup: 'Triceps',
          equipment: 'Cable',
          tutorialInstruction: 'Keep elbows pinned to your sides with full elbow extension',
          sets: [
            SetData(setNumber: 1, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
          ],
        ),
      ],
    ),
    WorkoutDay(
      id: 'day_2',
      title: 'DAY 2',
      subtitle: 'Chest & Shoulders',
      number: '2',
      exercises: [
        ExerciseItem(
          name: 'Incline Dumbbell Press',
          targetReps: '8-10',
          muscleGroup: 'Chest',
          equipment: 'Dumbbell',
          tutorialInstruction: 'Control the descent, press up and converge at the peak',
          sets: [
            SetData(setNumber: 1, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
          ],
        ),
        ExerciseItem(
          name: 'Lateral Raise',
          targetReps: '12-15',
          muscleGroup: 'Shoulders',
          equipment: 'Dumbbell',
          tutorialInstruction: 'Lead with the elbows and maintain a slight forward hinge',
          sets: [
            SetData(setNumber: 1, targetReps: '12-15', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '12-15', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '12-15', kg: '', rep: '', isCompleted: false),
          ],
        ),
      ],
    ),
    WorkoutDay(
      id: 'day_3',
      title: 'DAY 3',
      subtitle: 'Legs & Quads Focus',
      number: '3',
      exercises: [
        ExerciseItem(
          name: 'Barbell Squat',
          targetReps: '6-8',
          muscleGroup: 'Legs',
          equipment: 'Barbell',
          tutorialInstruction: 'Break at hips and knees simultaneously, descend to parallel',
          sets: [
            SetData(setNumber: 1, targetReps: '6-8', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '6-8', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '6-8', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 4, targetReps: '6-8', kg: '', rep: '', isCompleted: false),
          ],
        ),
        ExerciseItem(
          name: 'Leg Press',
          targetReps: '10-12',
          muscleGroup: 'Legs',
          equipment: 'Machine',
          tutorialInstruction: 'Feet shoulder-width on platform, avoid locking out knees at top',
          sets: [
            SetData(setNumber: 1, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
          ],
        ),
      ],
    ),
    WorkoutDay(
      id: 'day_4',
      title: 'DAY 4',
      subtitle: 'Back & Biceps',
      number: '4',
      exercises: [
        ExerciseItem(
          name: 'Lat Pulldown',
          targetReps: '8-10',
          muscleGroup: 'Back',
          equipment: 'Cable',
          tutorialInstruction: 'Pull down to clavicle while driving elbows down and back',
          sets: [
            SetData(setNumber: 1, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
          ],
        ),
        ExerciseItem(
          name: 'Bicep Barbell Curl',
          targetReps: '10-12',
          muscleGroup: 'Biceps',
          equipment: 'Barbell',
          tutorialInstruction: 'Pin elbows to sides, curl without swinging the torso',
          sets: [
            SetData(setNumber: 1, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
          ],
        ),
      ],
    ),
    WorkoutDay(
      id: 'day_5',
      title: 'DAY 5',
      subtitle: 'Hamstrings & Core',
      number: '5',
      exercises: [
        ExerciseItem(
          name: 'Romanian Deadlift',
          targetReps: '8-10',
          muscleGroup: 'Legs',
          equipment: 'Barbell',
          tutorialInstruction: 'Hinge back at the hips, keeping bar close to your shins',
          sets: [
            SetData(setNumber: 1, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '8-10', kg: '', rep: '', isCompleted: false),
          ],
        ),
        ExerciseItem(
          name: 'Overhead Tricep Extension',
          targetReps: '10-12',
          muscleGroup: 'Triceps',
          equipment: 'Cable',
          tutorialInstruction: 'Extend arms fully above head keeping upper arms stable',
          sets: [
            SetData(setNumber: 1, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 2, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
            SetData(setNumber: 3, targetReps: '10-12', kg: '', rep: '', isCompleted: false),
          ],
        ),
      ],
    ),
  ];

  List<WorkoutDay> get days => List.unmodifiable(_days);

  WorkoutDay getDay(String dayTitle) {
    return _days.firstWhere(
      (d) => d.title.trim().toUpperCase() == dayTitle.trim().toUpperCase(),
      orElse: () => _days.first,
    );
  }

  List<ExerciseItem> getExercisesForDay(String dayTitle) {
    return getDay(dayTitle).exercises;
  }

  void addExerciseToDay(String dayTitle, ExerciseItem exercise) {
    final dayIndex = _days.indexWhere(
      (d) => d.title.trim().toUpperCase() == dayTitle.trim().toUpperCase(),
    );

    if (dayIndex != -1) {
      _days[dayIndex].exercises.add(exercise);
      notifyListeners();
    }
  }

  void removeExerciseFromDay(String dayTitle, int exerciseIndex) {
    final day = getDay(dayTitle);
    if (exerciseIndex >= 0 && exerciseIndex < day.exercises.length) {
      day.exercises.removeAt(exerciseIndex);
      notifyListeners();
    }
  }

  void updateSetKg(String dayTitle, int exerciseIndex, int setIndex, String kg) {
    final exercises = getExercisesForDay(dayTitle);
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final sets = exercises[exerciseIndex].sets;
      if (setIndex >= 0 && setIndex < sets.length) {
        sets[setIndex].kg = kg;
        notifyListeners();
      }
    }
  }

  void updateSetRep(String dayTitle, int exerciseIndex, int setIndex, String rep) {
    final exercises = getExercisesForDay(dayTitle);
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final sets = exercises[exerciseIndex].sets;
      if (setIndex >= 0 && setIndex < sets.length) {
        sets[setIndex].rep = rep;
        notifyListeners();
      }
    }
  }

  void toggleSetCompleted(String dayTitle, int exerciseIndex, int setIndex) {
    final exercises = getExercisesForDay(dayTitle);
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final sets = exercises[exerciseIndex].sets;
      if (setIndex >= 0 && setIndex < sets.length) {
        sets[setIndex].isCompleted = !sets[setIndex].isCompleted;
        notifyListeners();
      }
    }
  }

  void addSetToExercise(String dayTitle, int exerciseIndex, {String targetReps = '8-10'}) {
    final exercises = getExercisesForDay(dayTitle);
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final sets = exercises[exerciseIndex].sets;
      final newSetNumber = sets.length + 1;
      sets.add(
        SetData(
          setNumber: newSetNumber,
          targetReps: targetReps,
          kg: sets.isNotEmpty ? sets.last.kg : '',
          rep: sets.isNotEmpty ? sets.last.rep : '',
          isCompleted: false,
        ),
      );
      notifyListeners();
    }
  }

  void removeSetFromExercise(String dayTitle, int exerciseIndex, int setIndex) {
    final exercises = getExercisesForDay(dayTitle);
    if (exerciseIndex >= 0 && exerciseIndex < exercises.length) {
      final sets = exercises[exerciseIndex].sets;
      if (setIndex >= 0 && setIndex < sets.length) {
        sets.removeAt(setIndex);
        // re-index remaining sets
        for (int i = 0; i < sets.length; i++) {
          sets[i] = sets[i].copyWith(setNumber: i + 1);
        }
        notifyListeners();
      }
    }
  }

  double calculateDayVolume(String dayTitle) {
    return getDay(dayTitle).totalVolume;
  }

  int completedSetsCount(String dayTitle) {
    return getDay(dayTitle).completedSetsCount;
  }

  int totalSetsCount(String dayTitle) {
    return getDay(dayTitle).totalSetsCount;
  }
}


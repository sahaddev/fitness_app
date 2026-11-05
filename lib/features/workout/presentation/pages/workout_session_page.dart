import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/providers.dart';
import 'exercise_history_page.dart';
import 'exercise_tutorial_page.dart';

// Re-export model classes for backwards compatibility
export '../providers/workout_provider.dart' show ExerciseItem, SetData;

class WorkoutSessionPage extends StatefulWidget {
  final String dayTitle;

  const WorkoutSessionPage({super.key, this.dayTitle = 'DAY 1'});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 32.0 : 18.0;

    final workoutProvider = context.watch<WorkoutProvider>();
    final exercises = workoutProvider.getExercisesForDay(widget.dayTitle);
    final completedSets = workoutProvider.completedSetsCount(widget.dayTitle);
    final totalSets = workoutProvider.totalSetsCount(widget.dayTitle);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: mediaQuery.padding.top > 0 ? 10 : 16),

            // Top Bar: Back Button + Day Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  _buildCircularButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dayTitle,
                          style: GoogleFonts.montserrat(
                            fontSize: isTablet ? 19 : 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '$completedSets of $totalSets sets completed',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: completedSets == totalSets && totalSets > 0
                                ? AppColors.gold
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exercise Cards List
            Expanded(
              child: exercises.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 8,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: exercises.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        if (index == exercises.length) {
                          return _buildSessionFooter(
                            context: context,
                            workoutProvider: workoutProvider,
                            isTablet: isTablet,
                          );
                        }
                        return _buildExerciseCard(
                          context: context,
                          exercise: exercises[index],
                          exerciseIndex: index,
                          isTablet: isTablet,
                          workoutProvider: workoutProvider,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_rounded,
            size: 54,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises for ${widget.dayTitle}',
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.circleButton,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 24)),
      ),
    );
  }

  Widget _buildExerciseCard({
    required BuildContext context,
    required ExerciseItem exercise,
    required int exerciseIndex,
    required bool isTablet,
    required WorkoutProvider workoutProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Exercise Title + History Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 19 : 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.history_rounded,
                        color: AppColors.gold,
                        size: 26,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 22,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseHistoryPage(
                              exerciseName: exercise.name,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Table Header
                Row(
                  children: [
                    _buildHeaderCell('SET', flex: 2),
                    _buildHeaderCell('REPS', flex: 3),
                    _buildHeaderCell('KG', flex: 3),
                    _buildHeaderCell('REP', flex: 3),
                    _buildHeaderCell('', flex: 2),
                  ],
                ),

                const SizedBox(height: 10),

                // Table Rows
                ...exercise.sets.asMap().entries.map((entry) {
                  final setIndex = entry.key;
                  final set = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        // SET Column
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cellBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${set.setNumber}',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // REPS Target Column
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cellBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              set.targetReps,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // KG Input Column (Outlined box)
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: set.isCompleted
                                    ? AppColors.gold
                                    : AppColors.cellBorder,
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              initialValue: set.kg,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                workoutProvider.updateSetKg(
                                  widget.dayTitle,
                                  exerciseIndex,
                                  setIndex,
                                  val,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Completed REP Input Column (Outlined box)
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: set.isCompleted
                                    ? AppColors.gold
                                    : AppColors.cellBorder,
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              initialValue: set.rep,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                workoutProvider.updateSetRep(
                                  widget.dayTitle,
                                  exerciseIndex,
                                  setIndex,
                                  val,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Checkmark Button
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              workoutProvider.toggleSetCompleted(
                                widget.dayTitle,
                                exerciseIndex,
                                setIndex,
                              );
                            },
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: set.isCompleted
                                    ? AppColors.gold.withValues(alpha: 0.25)
                                    : AppColors.cellBg,
                                borderRadius: BorderRadius.circular(6),
                                border: set.isCompleted
                                    ? Border.all(
                                        color: AppColors.gold,
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: set.isCompleted
                                      ? AppColors.gold
                                      : Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 6),

                // Add Set Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      workoutProvider.addSetToExercise(
                        widget.dayTitle,
                        exerciseIndex,
                      );
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      color: AppColors.gold,
                      size: 18,
                    ),
                    label: Text(
                      'Add Set',
                      style: GoogleFonts.poppins(
                        color: AppColors.gold,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tutorial Video Button (Bottom Bar)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseTutorialPage(
                    exerciseName: exercise.name,
                    instructionText: exercise.tutorialInstruction,
                  ),
                ),
              );
            },
            child: Container(
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.cardFooter,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tutorial Video',
                    style: GoogleFonts.poppins(
                      color: AppColors.gold,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: AppColors.gold,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionFooter({
    required BuildContext context,
    required WorkoutProvider workoutProvider,
    required bool isTablet,
  }) {
    final totalVol = workoutProvider.calculateDayVolume(widget.dayTitle);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Volume Lifted',
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${totalVol.toStringAsFixed(1)} kg',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Log to history provider
                final historyProvider = context.read<ExerciseHistoryProvider>();
                final exercises = workoutProvider.getExercisesForDay(widget.dayTitle);

                for (final ex in exercises) {
                  if (ex.completedSetsCount > 0) {
                    final setLogs = ex.sets
                        .where((s) => s.isCompleted)
                        .map(
                          (s) => HistorySetLog(
                            set: s.setNumber,
                            reps: s.rep.isNotEmpty ? s.rep : s.targetReps,
                            kg: s.kg.isNotEmpty ? s.kg : '0',
                            rep: s.rep.isNotEmpty ? s.rep : '0',
                            volume: s.volume.toInt(),
                          ),
                        )
                        .toList();

                    historyProvider.addSessionLog(
                      ex.name,
                      HistorySessionLog(
                        date: 'Today',
                        sets: setLogs,
                        totalVolume: ex.totalVolume.toInt(),
                      ),
                    );
                  }
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.dayTitle} session completed & logged!',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: AppColors.surface,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.black,
              ),
              label: Text(
                'COMPLETE WORKOUT',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

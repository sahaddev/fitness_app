import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'exercise_history_page.dart';
import 'exercise_tutorial_page.dart';

class WorkoutSessionPage extends StatefulWidget {
  final String dayTitle;

  const WorkoutSessionPage({super.key, this.dayTitle = 'DAY 1'});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  late List<ExerciseItem> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = [
      ExerciseItem(
        name: 'Seated upperback row',
        targetReps: '8-10',
        tutorialInstruction: 'Use the long bar lat pulldown attachment',
        sets: [
          SetData(
            setNumber: 1,
            targetReps: '8-10',
            kg: '',
            rep: '',
            isCompleted: false,
          ),
          SetData(
            setNumber: 2,
            targetReps: '8-10',
            kg: '',
            rep: '',
            isCompleted: false,
          ),
          SetData(
            setNumber: 3,
            targetReps: '8-10',
            kg: '',
            rep: '',
            isCompleted: false,
          ),
        ],
      ),
      ExerciseItem(
        name: 'Tricep pushdown',
        targetReps: '10-12',
        tutorialInstruction:
            'Keep elbows pinned to your sides with full elbow extension',
        sets: [
          SetData(
            setNumber: 1,
            targetReps: '10-12',
            kg: '',
            rep: '',
            isCompleted: false,
          ),
          SetData(
            setNumber: 2,
            targetReps: '10-12',
            kg: '',
            rep: '',
            isCompleted: false,
          ),
          SetData(
            setNumber: 3,
            targetReps: '10-12',
            kg: '',
            rep: '',
            isCompleted: false,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 32.0 : 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: mediaQuery.padding.top > 0 ? 10 : 16),

            // Top Bar: Back Button + Timer Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircularButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Exercise Cards List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: _exercises.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return _buildExerciseCard(
                    context: context,
                    exercise: _exercises[index],
                    isTablet: isTablet,
                  );
                },
              ),
            ),
          ],
        ),
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
    required bool isTablet,
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
                ...exercise.sets.map((set) {
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
                              onChanged: (val) => set.kg = val,
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
                              onChanged: (val) => set.rep = val,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Checkmark Button
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                set.isCompleted = !set.isCompleted;
                              });
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

class ExerciseItem {
  final String name;
  final String targetReps;
  final String tutorialInstruction;
  final List<SetData> sets;

  ExerciseItem({
    required this.name,
    required this.targetReps,
    required this.tutorialInstruction,
    required this.sets,
  });
}

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
}

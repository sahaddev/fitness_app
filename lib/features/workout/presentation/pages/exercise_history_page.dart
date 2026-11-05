import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/providers.dart';

// Re-export models for backwards compatibility
export '../providers/exercise_history_provider.dart'
    show HistorySessionLog, HistorySetLog;

class ExerciseHistoryPage extends StatelessWidget {
  final String exerciseName;

  const ExerciseHistoryPage({
    super.key,
    this.exerciseName = 'Seated upperback row',
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 32.0 : 18.0;

    final historyProvider = context.watch<ExerciseHistoryProvider>();
    final historyLogs = historyProvider.getLogsForExercise(exerciseName);
    final personalBestWeight = historyProvider.getPersonalBestWeight(exerciseName);
    final personalBestVolume = historyProvider.getPersonalBestVolume(exerciseName);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mediaQuery.padding.top > 0 ? 10 : 16),

            // Top Bar: Back Button + Exercise Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  _buildCircularBackButton(context),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      exerciseName,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 22 : 19,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Personal Best Summary Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Max Weight',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$personalBestWeight kg',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    Column(
                      children: [
                        Text(
                          'Peak Volume',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$personalBestVolume kg',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // History Log List
            Expanded(
              child: historyLogs.isEmpty
                  ? Center(
                      child: Text(
                        'No history logged yet for this exercise.',
                        style: GoogleFonts.poppins(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 8,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: historyLogs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 26),
                      itemBuilder: (context, index) {
                        return _buildHistorySessionItem(
                          log: historyLogs[index],
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

  Widget _buildCircularBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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
        child: const Center(
          child: Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySessionItem({
    required HistorySessionLog log,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Label (Golden)
        Text(
          'Date',
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 15 : 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 2),

        // Date Value (White bold)
        Text(
          log.date,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 21 : 18.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        // Table Column Headers: SET, REPS, KG, REP, VOLUME
        Row(
          children: [
            _buildTableHeaderCell('SET'),
            const SizedBox(width: 8),
            _buildTableHeaderCell('REPS'),
            const SizedBox(width: 8),
            _buildTableHeaderCell('KG'),
            const SizedBox(width: 8),
            _buildTableHeaderCell('REP'),
            const SizedBox(width: 8),
            _buildTableHeaderCell('VOLUME'),
          ],
        ),

        const SizedBox(height: 10),

        // Table Rows (Pill shaped / rounded dark boxes)
        ...log.sets.map((set) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                _buildTableCell('${set.set}'),
                const SizedBox(width: 8),
                _buildTableCell(set.reps),
                const SizedBox(width: 8),
                _buildTableCell(set.kg),
                const SizedBox(width: 8),
                _buildTableCell(set.rep),
                const SizedBox(width: 8),
                _buildTableCell('${set.volume}'),
              ],
            ),
          );
        }),

        const SizedBox(height: 12),

        // Total Volume Text (Golden)
        Text(
          'Total Volume: ${log.totalVolume}',
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String title) {
    return Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.cellBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}

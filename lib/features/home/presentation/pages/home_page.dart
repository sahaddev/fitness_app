import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../workout/presentation/pages/add_workout_page.dart';
import '../../../workout/presentation/pages/exercise_history_page.dart';
import '../../../workout/presentation/pages/sessions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _HomeDashboardView(
            isTablet: isTablet,
            onNavigateToSessions: () => setState(() => _currentNavIndex = 1),
            onNavigateToHistory: () => setState(() => _currentNavIndex = 2),
          ),
          const SessionsPage(),
          const ExerciseHistoryPage(exerciseName: 'Overall Progress'),
          _ProfilePlaceholderView(isTablet: isTablet),
        ],
      ),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  final bool isTablet;
  final VoidCallback onNavigateToSessions;
  final VoidCallback onNavigateToHistory;

  const _HomeDashboardView({
    required this.isTablet,
    required this.onNavigateToSessions,
    required this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final horizontalPadding = isTablet ? 32.0 : 18.0;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mediaQuery.padding.top > 0 ? 4 : 8),

            // Top Header: User Profile Greeting & Notification
            _buildHeader(context),

            const SizedBox(height: 30),

            // Daily Stats Row (Calories, Time, Volume)
            _buildDailyMetricsRow(),

            const SizedBox(height: 24),

            // Weekly Calendar Activity Strip
            _buildWeeklyStreakCard(),

            const SizedBox(height: 24),

            // Quick Access Grid
            _buildSectionHeader('EXPLORE & ACTIONS'),
            const SizedBox(height: 12),
            _buildQuickActionsGrid(context),
            const SizedBox(height: 12),

            _buildQuickActionsGrid(context),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Avatar with Gold Ring
        Container(
          width: isTablet ? 52 : 46,
          height: isTablet ? 52 : 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2),
            color: AppColors.surface,
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              color: Colors.white.withValues(alpha: 0.9),
              size: isTablet ? 28 : 24,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Greeting Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good day, Athlete 👋',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 14 : 12.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ready to Train?',
                style: GoogleFonts.montserrat(
                  fontSize: isTablet ? 22 : 18.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Add Shortcut Button
        _buildCircleButton(
          icon: Icons.add_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
            );
          },
        ),
        const SizedBox(width: 10),

        // Notification / History Shortcut Button
        _buildCircleButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNavigateToHistory,
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.circleButton,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 22)),
      ),
    );
  }

  Widget _buildDailyMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Calories',
            value: '540',
            unit: 'kcal',
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFFF6D3B),
            progress: 0.68,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStreakCard() {
    final days = [
      {'label': 'M', 'day': '2', 'done': true},
      {'label': 'T', 'day': '3', 'done': true},
      {'label': 'W', 'day': '4', 'done': true},
      {'label': 'T', 'day': '5', 'isToday': true, 'done': false},
      {'label': 'F', 'day': '6', 'done': false},
      {'label': 'S', 'day': '7', 'done': false},
      {'label': 'S', 'day': '8', 'done': false},
    ];

    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '4-Day Workout Streak',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'Nov 2 - 8',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((d) {
              final isToday = d['isToday'] == true;
              final isDone = d['done'] == true;

              return Column(
                children: [
                  Text(
                    d['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isToday ? AppColors.gold : AppColors.textMuted,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: isTablet ? 38 : 34,
                    height: isTablet ? 38 : 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday
                          ? AppColors.gold
                          : (isDone
                                ? AppColors.gold.withValues(alpha: 0.2)
                                : AppColors.surfaceLight),
                      border: isToday
                          ? Border.all(color: Colors.white, width: 2)
                          : (isDone
                                ? Border.all(
                                    color: AppColors.gold.withValues(
                                      alpha: 0.5,
                                    ),
                                  )
                                : null),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppColors.gold,
                            )
                          : Text(
                              d['day'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: isToday
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isToday
                                    ? Colors.black
                                    : AppColors.textSecondary,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionTile(
            title: 'Sessions',
            subtitle: '5 Days Routine',
            icon: Icons.calendar_view_week_rounded,
            iconColor: AppColors.gold,
            onTap: onNavigateToSessions,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionTile(
            title: 'Add Workout',
            subtitle: 'Custom Exercise',
            icon: Icons.add_circle_outline_rounded,
            iconColor: const Color(0xFF66BB6A),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePlaceholderView extends StatelessWidget {
  final bool isTablet;

  const _ProfilePlaceholderView({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32.0 : 18.0,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PROFILE & SETTINGS',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Athlete Account',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'athlete@fitness.app',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

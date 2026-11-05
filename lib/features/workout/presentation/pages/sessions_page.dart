import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'workout_session_page.dart';
import 'add_workout_page.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 32.0 : 18.0;

    final days = [
      {'day': 'DAY 1', 'number': '1'},
      {'day': 'DAY 2', 'number': '2'},
      {'day': 'DAY 3', 'number': '3'},
      {'day': 'DAY 4', 'number': '4'},
      {'day': 'DAY 5', 'number': '5'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mediaQuery.padding.top > 0 ? 12 : 20),

              // Top Bar: Back Button + SESSIONS Header
              Row(
                children: [
                  _buildCircularBackButton(context),
                  const SizedBox(width: 14),

                  // Avatar Badge with athlete icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6E727A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 22,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 10,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // SESSIONS Title
                  Text(
                    'SESSIONS',
                    style: GoogleFonts.montserrat(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Spacer(),
                  IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                ],
              ),

              SizedBox(height: isTablet ? 28 : 22),

              SizedBox(height: isTablet ? 28 : 22),

              // Section Title: "Choose your Day of the Week"
              Text(
                'Choose your Day of the Week',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 20 : 16.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: isTablet ? 18 : 14),

              // Days List
              ListView.separated(
                itemCount: days.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    SizedBox(height: isTablet ? 14 : 10),
                itemBuilder: (context, index) {
                  final item = days[index];
                  return _buildDayCard(
                    context: context,
                    dayText: item['day']!,
                    dayNumber: item['number']!,
                    isTablet: isTablet,
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(
          'Add Exercise',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
          );
        },
      ),
    );
  }

  Widget _buildCircularBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
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
        child: Center(
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard({
    required BuildContext context,
    required String dayText,
    required String dayNumber,
    required bool isTablet,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutSessionPage(dayTitle: dayText),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: isTablet ? 76 : 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.04),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Calendar Icon Box with Day number
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF6E727A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Top calendar header with two notches
                    Container(
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5A5D64),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 3,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          dayNumber,
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // DAY Text (Golden/Amber)
              Text(
                dayText,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 17 : 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 0.8,
                ),
              ),

              const Spacer(),

              // Circular Yellow Chevron Button
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

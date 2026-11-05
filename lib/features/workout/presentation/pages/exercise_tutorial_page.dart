import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/providers.dart';
import '../widgets/workout_video_thumbnail.dart';

class ExerciseTutorialPage extends StatelessWidget {
  final String exerciseName;
  final String instructionText;

  const ExerciseTutorialPage({
    super.key,
    this.exerciseName = 'Seated upperback row',
    this.instructionText = 'Use the long bar lat pulldown attachment',
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 32.0 : 18.0;

    final tutorialProvider = context.watch<ExerciseTutorialProvider>();

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

            const SizedBox(height: 24),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Player / Thumbnail
                    if (!tutorialProvider.isPlaying && tutorialProvider.playbackProgress == 0.0)
                      WorkoutVideoThumbnail(
                        height: isTablet ? 320 : screenWidth * 0.54,
                        onTap: () {
                          tutorialProvider.play();
                        },
                      )
                    else
                      _buildActiveVideoPlayer(
                        isTablet,
                        screenWidth,
                        tutorialProvider,
                      ),

                    const SizedBox(height: 22),

                    // Primary Instruction Text
                    Text(
                      instructionText,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Additional Form Tips & Execution Guide
                    _buildFormTipsCard(isTablet),

                    const SizedBox(height: 30),
                  ],
                ),
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

  Widget _buildActiveVideoPlayer(
    bool isTablet,
    double screenWidth,
    ExerciseTutorialProvider tutorial,
  ) {
    final playerHeight = isTablet ? 320.0 : screenWidth * 0.54;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: playerHeight,
        width: double.infinity,
        color: const Color(0xFF181A1D),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dark gradient background simulation
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Color(0xFF2A2D33),
                    Color(0xFF101114),
                  ],
                ),
              ),
            ),

            // Play / Pause Icon
            IconButton(
              iconSize: 52,
              icon: Icon(
                tutorial.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                color: AppColors.gold,
              ),
              onPressed: tutorial.togglePlayPause,
            ),

            // Video Controls Bottom Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                        activeTrackColor: AppColors.gold,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: AppColors.gold,
                      ),
                      child: Slider(
                        value: tutorial.playbackProgress,
                        onChanged: tutorial.seek,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tutorial.formattedCurrentTime,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          tutorial.formattedTotalTime,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormTipsCard(bool isTablet) {
    final tips = [
      'Grip the bar slightly wider than shoulder-width with an overhand grip.',
      'Keep your torso upright with a slight natural arch in the lower back.',
      'Pull the attachment toward your upper chest, retracting your shoulder blades.',
      'Control the eccentric return without letting your shoulders roll forward.',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.gold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Key Technique Cues',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 17 : 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 15 : 13.5,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

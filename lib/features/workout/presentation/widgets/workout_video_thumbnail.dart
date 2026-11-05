import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class WorkoutVideoThumbnail extends StatelessWidget {
  final double? height;
  final VoidCallback? onTap;
  final String? subtitle;

  const WorkoutVideoThumbnail({
    super.key,
    this.height,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = screenWidth > 600;

    final defaultHeight = height ?? (isTablet ? 260.0 : screenWidth * 0.52);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: defaultHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1D21),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Stylized Gym Background (deadlift aesthetic)
              CustomPaint(painter: _GymBackgroundPainter()),

              // EIT Academy Logo Brand Overlay
              Positioned(
                top: 18,
                left: 16,
                right: 16,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EIT Brand Icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'EIT',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'EIT ACADEMY',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'EDUCATE - IMPLEMENT - TRANSFORM',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w500,
                              fontSize: 7.5,
                              letterSpacing: 0.8,
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
      ),
    );
  }
}

class _GymBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gym floor & barbell visual effect
    final bgPaint = Paint()..color = const Color(0xFF23252A);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final floorPaint = Paint()..color = const Color(0xFF181A1D);
    final floorPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(floorPath, floorPaint);

    // Subtle floor texture lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.5;
    for (double i = -size.width; i < size.width * 2; i += 40) {
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + 120, size.height * 0.4),
        linePaint,
      );
    }

    // Weight plate silhouette on the right
    final platePaint = Paint()..color = const Color(0xFF141517);
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.52),
      size.height * 0.42,
      platePaint,
    );

    final plateRingPaint = Paint()
      ..color = const Color(0xFF2C2F36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.52),
      size.height * 0.35,
      plateRingPaint,
    );

    // Barbell metal bar
    final barPaint = Paint()
      ..color = const Color(0xFF5D6169)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.92, size.height * 0.48),
      barPaint,
    );

    // Hands gripping barbell
    final armPaint = Paint()
      ..color = const Color(0xFF453026)
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.2),
      Offset(size.width * 0.18, size.height * 0.7),
      armPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.2),
      Offset(size.width * 0.38, size.height * 0.65),
      armPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

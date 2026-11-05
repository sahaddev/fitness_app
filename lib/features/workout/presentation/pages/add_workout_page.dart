import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import 'workout_session_page.dart';

class AddWorkoutPage extends StatefulWidget {
  final String? initialDay;

  const AddWorkoutPage({super.key, this.initialDay});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionController = TextEditingController();
  final _videoUrlController = TextEditingController();

  late String _selectedDay;
  String _selectedMuscle = 'Back';
  String _selectedEquipment = 'Cable';
  int _setCount = 3;
  String _selectedRepRange = '8-10';

  final List<String> _days = ['DAY 1', 'DAY 2', 'DAY 3', 'DAY 4'];

  final List<String> _muscleGroups = [
    'Back',
    'Chest',
    'Shoulders',
    'Triceps',
    'Biceps',
    'Legs',
    'Core',
  ];

  final List<String> _equipmentList = [
    'Cable',
    'Barbell',
    'Dumbbell',
    'Machine',
    'Bodyweight',
  ];

  final List<String> _repRangePresets = [
    '5',
    '6-8',
    '8-10',
    '10-12',
    '12-15',
    '15-20',
  ];

  final List<Map<String, String>> _quickSuggestions = [
    {'name': 'Lat Pulldown', 'muscle': 'Back', 'equipment': 'Cable'},
    {
      'name': 'Incline Dumbbell Press',
      'muscle': 'Chest',
      'equipment': 'Dumbbell',
    },
    {
      'name': 'Overhead Tricep Extension',
      'muscle': 'Triceps',
      'equipment': 'Cable',
    },
    {'name': 'Lateral Raise', 'muscle': 'Shoulders', 'equipment': 'Dumbbell'},
    {'name': 'Leg Press', 'muscle': 'Legs', 'equipment': 'Machine'},
    {'name': 'Barbell Squat', 'muscle': 'Legs', 'equipment': 'Barbell'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay ?? 'DAY 1';
    _instructionController.text =
        'Maintain strict form and control the eccentric motion.';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final instruction = _instructionController.text.trim();

      final newExercise = ExerciseItem(
        name: name,
        targetReps: _selectedRepRange,
        tutorialInstruction: instruction.isNotEmpty
            ? instruction
            : 'Focus on full range of motion and controlled tempo.',
        sets: List.generate(
          _setCount,
          (index) => SetData(
            setNumber: index + 1,
            targetReps: _selectedRepRange,
            kg: '',
            rep: '',
            isCompleted: false,
          ),
        ),
      );

      Navigator.pop(context, newExercise);
    }
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

            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  _buildCircularBackButton(context),
                  const SizedBox(width: 16),
                  Text(
                    'Add Workout Exercise',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 22 : 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Target Day Selector
                      _buildSectionTitle('Target Session', isTablet),
                      const SizedBox(height: 10),
                      _buildDaySelector(),

                      const SizedBox(height: 22),

                      // Exercise Name Input
                      _buildSectionTitle('Exercise Name', isTablet),
                      const SizedBox(height: 10),
                      _buildExerciseNameField(),

                      const SizedBox(height: 14),

                      // Quick Suggestions
                      _buildQuickSuggestions(),

                      const SizedBox(height: 24),

                      // Target Muscle Group Chips
                      _buildSectionTitle('Muscle Group', isTablet),
                      const SizedBox(height: 10),
                      _buildChipsSelector(
                        items: _muscleGroups,
                        selectedItem: _selectedMuscle,
                        onSelected: (val) =>
                            setState(() => _selectedMuscle = val),
                      ),

                      const SizedBox(height: 24),

                      // Equipment Type Chips
                      _buildSectionTitle('Equipment', isTablet),
                      const SizedBox(height: 10),
                      _buildChipsSelector(
                        items: _equipmentList,
                        selectedItem: _selectedEquipment,
                        onSelected: (val) =>
                            setState(() => _selectedEquipment = val),
                      ),

                      const SizedBox(height: 24),

                      // Sets & Reps Configuration
                      _buildSectionTitle('Sets & Target Reps', isTablet),
                      const SizedBox(height: 12),
                      _buildSetsAndRepsConfig(isTablet),

                      const SizedBox(height: 24),

                      // Tutorial Video & Technique Notes
                      _buildSectionTitle('Form Cue / Instructions', isTablet),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _instructionController,
                        hintText: 'e.g. Use long bar lat pulldown attachment',
                        maxLines: 2,
                        prefixIcon: Icons.notes_rounded,
                      ),

                      const SizedBox(height: 16),

                      _buildSectionTitle(
                        'Tutorial Video URL (Optional)',
                        isTablet,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _videoUrlController,
                        hintText: 'e.g. https://youtube.com/watch?v=...',
                        prefixIcon: Icons.play_circle_outline_rounded,
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      _buildSubmitButton(isTablet),

                      SizedBox(height: mediaQuery.padding.bottom + 20),
                    ],
                  ),
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

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: isTablet ? 16 : 14.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDaySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _days.map((day) {
          final isSelected = _selectedDay == day;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                day,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected ? Colors.black87 : AppColors.gold,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.gold,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected
                    ? AppColors.gold
                    : Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (selected) {
                if (selected) setState(() => _selectedDay = day);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExerciseNameField() {
    return TextFormField(
      controller: _nameController,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an exercise name';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'e.g. Seated Cable Row',
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.fitness_center_rounded,
          color: AppColors.gold,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _quickSuggestions.map((item) {
        return InkWell(
          onTap: () {
            setState(() {
              _nameController.text = item['name']!;
              _selectedMuscle = item['muscle']!;
              _selectedEquipment = item['equipment']!;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cellBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded, color: AppColors.gold, size: 14),
                const SizedBox(width: 4),
                Text(
                  item['name']!,
                  style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipsSelector({
    required List<String> items,
    required String selectedItem,
    required ValueChanged<String> onSelected,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items.map((item) {
          final isSelected = selectedItem == item;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                item,
                style: GoogleFonts.poppins(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                  color: isSelected ? Colors.black87 : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.gold,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected
                    ? AppColors.gold
                    : Colors.white.withValues(alpha: 0.06),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (selected) {
                if (selected) onSelected(item);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSetsAndRepsConfig(bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Set Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Sets',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Configures initial set rows',
                    style: GoogleFonts.poppins(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCounterButton(
                    icon: Icons.remove_rounded,
                    onTap: () {
                      if (_setCount > 1) {
                        setState(() => _setCount--);
                      }
                    },
                  ),
                  Container(
                    width: 44,
                    alignment: Alignment.center,
                    child: Text(
                      '$_setCount',
                      style: GoogleFonts.poppins(
                        color: AppColors.gold,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildCounterButton(
                    icon: Icons.add_rounded,
                    onTap: () {
                      if (_setCount < 10) {
                        setState(() => _setCount++);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Colors.white12, height: 1),
          ),

          // Target Rep Range
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Target Rep Range',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _repRangePresets.map((range) {
                    final isSelected = _selectedRepRange == range;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedRepRange = range),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.cellBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.cellBorder,
                            ),
                          ),
                          child: Text(
                            range,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.cellBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textMuted,
          fontSize: 13.5,
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.gold, size: 20),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isTablet) {
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 56 : 52,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_task_rounded, size: 22, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              'Save & Add to Session',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 17 : 15.5,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

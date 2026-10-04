import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/workout_record.dart';
import '../services/storage_service.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'strength';
  int _durationMinutes = 30;
  int _caloriesBurned = 250;
  final TextEditingController _notesController = TextEditingController();
  
  final List<Map<String, dynamic>> _workoutTypes = [
    {'id': 'strength', 'name': 'Strength Training', 'emoji': '🏋️', 'color': AppTheme.primaryOrange},
    {'id': 'cardio', 'name': 'Cardio', 'emoji': '🏃', 'color': AppTheme.successGreen},
    {'id': 'yoga', 'name': 'Yoga & Stretch', 'emoji': '🧘', 'color': AppTheme.deepBlue},
    {'id': 'outdoor', 'name': 'Outdoor Activity', 'emoji': '🚴', 'color': AppTheme.warningAmber},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveWorkout() async {
    // Create a simple workout record
    final workout = WorkoutRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      workoutType: _selectedType,
      exercises: [], // Simplified for initial version
      durationMinutes: _durationMinutes,
      caloriesBurned: _caloriesBurned,
      notes: _notesController.text,
    );

    await StorageService.saveWorkout(workout);
    
    // Update user stats
    final user = StorageService.getUserProfile();
    if (user != null) {
      user.updateWorkoutStats(_durationMinutes, _caloriesBurned);
      
      // Check for achievements
      final newAchievements = await StorageService.checkAndUnlockAchievements(user);
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Workout saved successfully!'),
            backgroundColor: AppTheme.successGreen,
            duration: Duration(seconds: 2),
          ),
        );

        // Show achievement unlocks if any
        for (var achievement in newAchievements) {
          if (mounted) {
            _showAchievementDialog(achievement);
          }
        }

        Navigator.pop(context, true);
      }
    }
  }

  void _showAchievementDialog(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏆 Achievement Unlocked!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              achievement.emoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              achievement.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Add Workout'),
        actions: [
          TextButton(
            onPressed: _saveWorkout,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Type Selection
            const Text(
              'Workout Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _workoutTypes.length,
              itemBuilder: (context, index) {
                final type = _workoutTypes[index];
                final isSelected = _selectedType == type['id'];
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedType = type['id'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? type['color'] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? type['color'] : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          type['emoji'],
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Date and Time
            const Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.cardDecoration(),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: AppTheme.primaryOrange),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('MMM d, yyyy').format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.cardDecoration(),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: AppTheme.primaryOrange),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('h:mm a').format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Duration
            const Text(
              'Duration (minutes)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '⏱️ Duration',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '$_durationMinutes min',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _durationMinutes.toDouble(),
                    min: 5,
                    max: 180,
                    divisions: 35,
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (value) {
                      setState(() {
                        _durationMinutes = value.toInt();
                        _caloriesBurned = (_durationMinutes * 8.5).toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Calories
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🔥 Calories Burned',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '$_caloriesBurned cal',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _caloriesBurned.toDouble(),
                    min: 50,
                    max: 1000,
                    divisions: 95,
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (value) {
                      setState(() {
                        _caloriesBurned = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notes
            const Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'How did you feel? Any achievements?',
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Workout 💪',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

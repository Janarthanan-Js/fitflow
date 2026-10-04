import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/workout_record.dart';
import 'add_workout_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  List<WorkoutRecord> _workouts = [];
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() {
    setState(() {
      _workouts = StorageService.getAllWorkouts();
    });
  }

  List<WorkoutRecord> get _filteredWorkouts {
    if (_filterType == 'all') return _workouts;
    return _workouts.where((w) => w.workoutType == _filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Workouts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Filter chips
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all', '🏋️'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Strength', 'strength', '🏋️'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Cardio', 'cardio', '🏃'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Yoga', 'yoga', '🧘'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Outdoor', 'outdoor', '🚴'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Workouts list
          _filteredWorkouts.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Text('💪', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          const Text(
                            'No workouts found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _filterType == 'all'
                                ? 'Start tracking your fitness journey!'
                                : 'Try a different filter or add a new workout',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final workout = _filteredWorkouts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildWorkoutCard(workout),
                        );
                      },
                      childCount: _filteredWorkouts.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutScreen()),
          );
          if (result == true) {
            _loadWorkouts();
          }
        },
        backgroundColor: AppTheme.primaryOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Workout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String emoji) {
    final isSelected = _filterType == value;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterType = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryOrange,
      side: BorderSide(
        color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutRecord workout) {
    return Dismissible(
      key: Key(workout.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Workout'),
            content: const Text('Are you sure you want to delete this workout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        await StorageService.deleteWorkout(workout.id);
        _loadWorkouts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout deleted'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.errorRed,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Container(
        decoration: AppTheme.cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        workout.workoutTypeEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.workoutTypeName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, MMM d, yyyy').format(workout.date),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatBadge('⏱️', '${workout.durationMinutes} min'),
                  const SizedBox(width: 12),
                  _buildStatBadge('🔥', '${workout.caloriesBurned} cal'),
                  const SizedBox(width: 12),
                  _buildStatBadge('🕐', DateFormat('h:mm a').format(workout.date)),
                ],
              ),
              if (workout.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    workout.notes,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.primaryOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

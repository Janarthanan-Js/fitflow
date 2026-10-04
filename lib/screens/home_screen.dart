import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/workout_record.dart';
import '../models/user_profile.dart';
import 'add_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? _user;
  List<WorkoutRecord> _recentWorkouts = [];
  bool _hasWorkoutToday = false;
  int _weeklyProgress = 0;

  final List<String> _motivationalQuotes = [
    '"The only bad workout is the one that didn\'t happen." 💪',
    '"Your body can stand almost anything. It\'s your mind you have to convince." 🧠',
    '"Take care of your body. It\'s the only place you have to live." 🏠',
    '"The pain you feel today will be the strength you feel tomorrow." ⚡',
    '"Push yourself because no one else is going to do it for you." 🚀',
    '"Success starts with self-discipline." 🎯',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _user = StorageService.getUserProfile();
      _recentWorkouts = StorageService.getAllWorkouts().take(5).toList();
      _hasWorkoutToday = _checkTodayWorkout();
      _weeklyProgress = _calculateWeeklyProgress();
      
      // Update current streak
      if (_user != null) {
        final streak = StorageService.calculateCurrentStreak();
        _user!.updateStreak(streak);
      }
    });
  }

  bool _checkTodayWorkout() {
    final today = DateTime.now();
    return _recentWorkouts.any((workout) {
      return workout.date.year == today.year &&
          workout.date.month == today.month &&
          workout.date.day == today.day;
    });
  }

  int _calculateWeeklyProgress() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final weekWorkouts = StorageService.getWorkoutsByDateRange(startOfWeek, endOfWeek);
    return weekWorkouts.length;
  }

  @override
  Widget build(BuildContext context) {
    final quote = _motivationalQuotes[DateTime.now().day % _motivationalQuotes.length];
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'FitFlow',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundColor: AppTheme.primaryOrange,
                    child: Text(
                      _user?.name[0].toUpperCase() ?? 'F',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Overview Card
                    _buildTodayOverviewCard(),
                    const SizedBox(height: 16),
                    
                    // Quick Start Button
                    _buildQuickStartButton(),
                    const SizedBox(height: 16),
                    
                    // Motivational Quote
                    _buildMotivationalQuote(quote),
                    const SizedBox(height: 24),
                    
                    // Recent Workouts
                    _buildSectionTitle('Recent Activity 📝'),
                    const SizedBox(height: 12),
                    _buildRecentWorkouts(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayOverviewCard() {
    return Container(
      decoration: AppTheme.gradientDecoration(AppTheme.primaryGradient),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE, MMM d').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _hasWorkoutToday ? '✅' : '⏰',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '🔥 Streak',
                  '${_user?.currentStreak ?? 0} days',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '📅 This Week',
                  '$_weeklyProgress/7 days',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '🏆 Total',
                  '${_user?.totalWorkouts ?? 0} workouts',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStartButton() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddWorkoutScreen()),
        );
        if (result == true) {
          _loadData();
        }
      },
      child: Container(
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start New Workout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Log your training session',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.primaryOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(String quote) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              quote,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textDark,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildRecentWorkouts() {
    if (_recentWorkouts.isEmpty) {
      return Container(
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Column(
            children: [
              Text('🏋️', style: TextStyle(fontSize: 48)),
              SizedBox(height: 16),
              Text(
                'No workouts yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Start your fitness journey today!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _recentWorkouts.map((workout) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: AppTheme.cardDecoration(),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    workout.workoutTypeEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              title: Text(
                workout.workoutTypeName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(workout.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildWorkoutBadge('⏱️ ${workout.durationMinutes} min'),
                      const SizedBox(width: 8),
                      _buildWorkoutBadge('🔥 ${workout.caloriesBurned} cal'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.primaryOrange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

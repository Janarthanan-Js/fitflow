import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_record.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String workoutBox = 'workouts';
  static const String userBox = 'user';
  static const String metricsBox = 'metrics';
  static const String plansBox = 'plans';
  static const String achievementsBox = 'achievements';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(WorkoutRecordAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(ExerciseSetAdapter());
    Hive.registerAdapter(BodyMetricsAdapter());
    Hive.registerAdapter(WorkoutPlanAdapter());
    Hive.registerAdapter(DailyPlanAdapter());
    Hive.registerAdapter(AchievementAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    
    // Open boxes
    await Hive.openBox<WorkoutRecord>(workoutBox);
    await Hive.openBox<UserProfile>(userBox);
    await Hive.openBox<BodyMetrics>(metricsBox);
    await Hive.openBox<WorkoutPlan>(plansBox);
    await Hive.openBox<Achievement>(achievementsBox);
  }

  // Workout operations
  static Box<WorkoutRecord> getWorkoutBox() {
    return Hive.box<WorkoutRecord>(workoutBox);
  }

  static Future<void> saveWorkout(WorkoutRecord workout) async {
    final box = getWorkoutBox();
    await box.put(workout.id, workout);
  }

  static List<WorkoutRecord> getAllWorkouts() {
    final box = getWorkoutBox();
    final workouts = box.values.toList();
    workouts.sort((a, b) => b.date.compareTo(a.date));
    return workouts;
  }

  static List<WorkoutRecord> getWorkoutsByDateRange(DateTime start, DateTime end) {
    final box = getWorkoutBox();
    return box.values.where((workout) {
      return workout.date.isAfter(start.subtract(const Duration(days: 1))) &&
             workout.date.isBefore(end.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> deleteWorkout(String id) async {
    final box = getWorkoutBox();
    await box.delete(id);
  }

  // User profile operations
  static Box<UserProfile> getUserBox() {
    return Hive.box<UserProfile>(userBox);
  }

  static UserProfile? getUserProfile() {
    final box = getUserBox();
    if (box.isEmpty) {
      final newUser = UserProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Fitness Enthusiast',
        joinDate: DateTime.now(),
      );
      box.put('current_user', newUser);
      return newUser;
    }
    return box.get('current_user');
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    final box = getUserBox();
    await box.put('current_user', profile);
  }

  // Body metrics operations
  static Box<BodyMetrics> getMetricsBox() {
    return Hive.box<BodyMetrics>(metricsBox);
  }

  static Future<void> saveBodyMetrics(BodyMetrics metrics) async {
    final box = getMetricsBox();
    await box.put(metrics.id, metrics);
  }

  static List<BodyMetrics> getAllMetrics() {
    final box = getMetricsBox();
    final metrics = box.values.toList();
    metrics.sort((a, b) => b.date.compareTo(a.date));
    return metrics;
  }

  // Workout plan operations
  static Box<WorkoutPlan> getPlansBox() {
    return Hive.box<WorkoutPlan>(plansBox);
  }

  static Future<void> savePlan(WorkoutPlan plan) async {
    final box = getPlansBox();
    await box.put(plan.id, plan);
  }

  static List<WorkoutPlan> getAllPlans() {
    final box = getPlansBox();
    return box.values.toList();
  }

  static WorkoutPlan? getActivePlan() {
    final box = getPlansBox();
    try {
      return box.values.firstWhere((plan) => plan.isActive);
    } catch (e) {
      return null;
    }
  }

  // Achievement operations
  static Box<Achievement> getAchievementsBox() {
    return Hive.box<Achievement>(achievementsBox);
  }

  static Future<void> saveAchievement(Achievement achievement) async {
    final box = getAchievementsBox();
    await box.put(achievement.id, achievement);
  }

  static List<Achievement> getAllAchievements() {
    final box = getAchievementsBox();
    return box.values.toList();
  }

  static Future<void> initializeAchievements() async {
    final box = getAchievementsBox();
    if (box.isEmpty) {
      final achievements = [
        Achievement(
          id: 'first_workout',
          name: 'First Step',
          description: 'Complete your first workout',
          emoji: '🎯',
        ),
        Achievement(
          id: 'streak_7',
          name: 'Week Warrior',
          description: 'Maintain a 7-day workout streak',
          emoji: '🔥',
        ),
        Achievement(
          id: 'streak_30',
          name: 'Monthly Champion',
          description: 'Maintain a 30-day workout streak',
          emoji: '🏆',
        ),
        Achievement(
          id: 'streak_100',
          name: 'Century Club',
          description: 'Maintain a 100-day workout streak',
          emoji: '💯',
        ),
        Achievement(
          id: 'workouts_50',
          name: 'Half Century',
          description: 'Complete 50 workouts',
          emoji: '⭐',
        ),
        Achievement(
          id: 'workouts_100',
          name: 'Centurion',
          description: 'Complete 100 workouts',
          emoji: '🎖️',
        ),
        Achievement(
          id: 'hours_50',
          name: 'Time Commitment',
          description: 'Train for 50 hours total',
          emoji: '⏱️',
        ),
        Achievement(
          id: 'calories_10000',
          name: 'Calorie Crusher',
          description: 'Burn 10,000 calories total',
          emoji: '🔥',
        ),
      ];

      for (var achievement in achievements) {
        await box.put(achievement.id, achievement);
      }
    }
  }

  // Calculate workout streak
  static int calculateCurrentStreak() {
    final workouts = getAllWorkouts();
    if (workouts.isEmpty) return 0;

    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    // Normalize to start of day
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    for (int i = 0; i < 365; i++) {
      final checkDate = currentDate.subtract(Duration(days: i));
      final hasWorkout = workouts.any((w) {
        final workoutDate = DateTime(w.date.year, w.date.month, w.date.day);
        return workoutDate.isAtSameMomentAs(checkDate);
      });

      if (hasWorkout) {
        streak++;
      } else if (i > 0) {
        // If it's not today and no workout found, break the streak
        break;
      }
    }

    return streak;
  }

  // Check and unlock achievements
  static Future<List<Achievement>> checkAndUnlockAchievements(UserProfile user) async {
    final achievementsBox = getAchievementsBox();
    final unlockedList = <Achievement>[];

    for (var achievement in achievementsBox.values) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_workout':
          shouldUnlock = user.totalWorkouts >= 1;
          break;
        case 'streak_7':
          shouldUnlock = user.currentStreak >= 7;
          break;
        case 'streak_30':
          shouldUnlock = user.currentStreak >= 30;
          break;
        case 'streak_100':
          shouldUnlock = user.currentStreak >= 100;
          break;
        case 'workouts_50':
          shouldUnlock = user.totalWorkouts >= 50;
          break;
        case 'workouts_100':
          shouldUnlock = user.totalWorkouts >= 100;
          break;
        case 'hours_50':
          shouldUnlock = user.totalHours >= 50;
          break;
        case 'calories_10000':
          shouldUnlock = user.totalCalories >= 10000;
          break;
      }

      if (shouldUnlock) {
        achievement.isUnlocked = true;
        achievement.unlockedDate = DateTime.now();
        await achievement.save();
        user.unlockAchievement(achievement.id);
        unlockedList.add(achievement);
      }
    }

    return unlockedList;
  }
}

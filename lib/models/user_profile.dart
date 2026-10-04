import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 7)
class UserProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? avatarPath;

  @HiveField(3)
  DateTime joinDate;

  @HiveField(4)
  int totalWorkouts;

  @HiveField(5)
  int currentStreak;

  @HiveField(6)
  int longestStreak;

  @HiveField(7)
  int totalMinutes;

  @HiveField(8)
  int totalCalories;

  @HiveField(9)
  String memberLevel; // bronze, silver, gold, platinum, diamond

  @HiveField(10)
  List<String> unlockedAchievements;

  @HiveField(11)
  String preferredUnit; // kg or lb

  @HiveField(12)
  bool darkMode;

  UserProfile({
    required this.id,
    required this.name,
    this.avatarPath,
    required this.joinDate,
    this.totalWorkouts = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalMinutes = 0,
    this.totalCalories = 0,
    this.memberLevel = 'bronze',
    List<String>? unlockedAchievements,
    this.preferredUnit = 'kg',
    this.darkMode = false,
  }) : unlockedAchievements = unlockedAchievements ?? [];

  int get workoutDays => totalWorkouts;
  
  double get totalHours => totalMinutes / 60.0;
  
  String get levelEmoji {
    switch (memberLevel.toLowerCase()) {
      case 'bronze':
        return '🥉';
      case 'silver':
        return '🥈';
      case 'gold':
        return '🥇';
      case 'platinum':
        return '💎';
      case 'diamond':
        return '💎';
      default:
        return '🥉';
    }
  }

  String get levelName {
    return '${memberLevel[0].toUpperCase()}${memberLevel.substring(1)} Member';
  }

  void updateWorkoutStats(int duration, int calories) {
    totalWorkouts++;
    totalMinutes += duration;
    totalCalories += calories;
    save();
  }

  void updateStreak(int newStreak) {
    currentStreak = newStreak;
    if (newStreak > longestStreak) {
      longestStreak = newStreak;
    }
    save();
  }

  void unlockAchievement(String achievementId) {
    if (!unlockedAchievements.contains(achievementId)) {
      unlockedAchievements.add(achievementId);
      save();
    }
  }
}

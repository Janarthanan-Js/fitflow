import 'package:hive/hive.dart';

part 'workout_record.g.dart';

@HiveType(typeId: 0)
class WorkoutRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String workoutType; // strength, cardio, yoga, outdoor

  @HiveField(3)
  List<Exercise> exercises;

  @HiveField(4)
  int durationMinutes;

  @HiveField(5)
  int caloriesBurned;

  @HiveField(6)
  String notes;

  @HiveField(7)
  List<String>? imagePaths;

  WorkoutRecord({
    required this.id,
    required this.date,
    required this.workoutType,
    required this.exercises,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.notes = '',
    this.imagePaths,
  });

  String get workoutTypeEmoji {
    switch (workoutType.toLowerCase()) {
      case 'strength':
        return '🏋️';
      case 'cardio':
        return '🏃';
      case 'yoga':
        return '🧘';
      case 'outdoor':
        return '🚴';
      default:
        return '💪';
    }
  }

  String get workoutTypeName {
    switch (workoutType.toLowerCase()) {
      case 'strength':
        return 'Strength Training';
      case 'cardio':
        return 'Cardio';
      case 'yoga':
        return 'Yoga & Stretch';
      case 'outdoor':
        return 'Outdoor Activity';
      default:
        return 'Workout';
    }
  }
}

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String bodyPart; // chest, back, legs, arms, core, cardio

  @HiveField(2)
  List<ExerciseSet> sets;

  Exercise({
    required this.name,
    required this.bodyPart,
    required this.sets,
  });

  String get bodyPartEmoji {
    switch (bodyPart.toLowerCase()) {
      case 'chest':
        return '💪';
      case 'back':
        return '🦸';
      case 'legs':
        return '🦵';
      case 'arms':
        return '💪';
      case 'core':
        return '🔥';
      case 'cardio':
        return '❤️';
      default:
        return '💪';
    }
  }
}

@HiveType(typeId: 2)
class ExerciseSet extends HiveObject {
  @HiveField(0)
  int setNumber;

  @HiveField(1)
  int reps;

  @HiveField(2)
  double? weight; // in kg

  @HiveField(3)
  int? restSeconds;

  ExerciseSet({
    required this.setNumber,
    required this.reps,
    this.weight,
    this.restSeconds,
  });
}

@HiveType(typeId: 3)
class BodyMetrics extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  double? weight; // kg

  @HiveField(3)
  double? bodyFat; // percentage

  @HiveField(4)
  Map<String, double>? measurements; // chest, waist, hips, etc.

  @HiveField(5)
  String? photoPath;

  BodyMetrics({
    required this.id,
    required this.date,
    this.weight,
    this.bodyFat,
    this.measurements,
    this.photoPath,
  });
}

@HiveType(typeId: 4)
class WorkoutPlan extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String difficulty; // beginner, intermediate, advanced

  @HiveField(4)
  int durationWeeks;

  @HiveField(5)
  List<DailyPlan> dailyPlans;

  @HiveField(6)
  bool isActive;

  @HiveField(7)
  DateTime? startDate;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.durationWeeks,
    required this.dailyPlans,
    this.isActive = false,
    this.startDate,
  });

  String get difficultyEmoji {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '⭐';
      case 'intermediate':
        return '⭐⭐';
      case 'advanced':
        return '⭐⭐⭐';
      default:
        return '⭐';
    }
  }
}

@HiveType(typeId: 5)
class DailyPlan extends HiveObject {
  @HiveField(0)
  int dayNumber;

  @HiveField(1)
  String dayType; // strength, cardio, rest

  @HiveField(2)
  List<String> exercises;

  @HiveField(3)
  int targetDuration; // minutes

  @HiveField(4)
  bool isCompleted;

  DailyPlan({
    required this.dayNumber,
    required this.dayType,
    required this.exercises,
    required this.targetDuration,
    this.isCompleted = false,
  });
}

@HiveType(typeId: 6)
class Achievement extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String emoji;

  @HiveField(4)
  DateTime? unlockedDate;

  @HiveField(5)
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.unlockedDate,
    this.isUnlocked = false,
  });
}

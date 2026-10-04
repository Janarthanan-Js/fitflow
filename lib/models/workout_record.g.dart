// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutRecordAdapter extends TypeAdapter<WorkoutRecord> {
  @override
  final int typeId = 0;

  @override
  WorkoutRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutRecord(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      workoutType: fields[2] as String,
      exercises: (fields[3] as List).cast<Exercise>(),
      durationMinutes: fields[4] as int,
      caloriesBurned: fields[5] as int,
      notes: fields[6] as String,
      imagePaths: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.workoutType)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.caloriesBurned)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.imagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      name: fields[0] as String,
      bodyPart: fields[1] as String,
      sets: (fields[2] as List).cast<ExerciseSet>(),
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bodyPart)
      ..writeByte(2)
      ..write(obj.sets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseSetAdapter extends TypeAdapter<ExerciseSet> {
  @override
  final int typeId = 2;

  @override
  ExerciseSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSet(
      setNumber: fields[0] as int,
      reps: fields[1] as int,
      weight: fields[2] as double?,
      restSeconds: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.setNumber)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.restSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BodyMetricsAdapter extends TypeAdapter<BodyMetrics> {
  @override
  final int typeId = 3;

  @override
  BodyMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyMetrics(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      weight: fields[2] as double?,
      bodyFat: fields[3] as double?,
      measurements: (fields[4] as Map?)?.cast<String, double>(),
      photoPath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BodyMetrics obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.bodyFat)
      ..writeByte(4)
      ..write(obj.measurements)
      ..writeByte(5)
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 4;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      difficulty: fields[3] as String,
      durationWeeks: fields[4] as int,
      dailyPlans: (fields[5] as List).cast<DailyPlan>(),
      isActive: fields[6] as bool,
      startDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.durationWeeks)
      ..writeByte(5)
      ..write(obj.dailyPlans)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyPlanAdapter extends TypeAdapter<DailyPlan> {
  @override
  final int typeId = 5;

  @override
  DailyPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyPlan(
      dayNumber: fields[0] as int,
      dayType: fields[1] as String,
      exercises: (fields[2] as List).cast<String>(),
      targetDuration: fields[3] as int,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyPlan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dayNumber)
      ..writeByte(1)
      ..write(obj.dayType)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.targetDuration)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 6;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      emoji: fields[3] as String,
      unlockedDate: fields[4] as DateTime?,
      isUnlocked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.unlockedDate)
      ..writeByte(5)
      ..write(obj.isUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

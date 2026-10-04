import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/workout_record.dart';
import '../models/user_profile.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  UserProfile? _user;
  List<WorkoutRecord> _workouts = [];
  int _selectedDays = 30;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _user = StorageService.getUserProfile();
      _workouts = StorageService.getAllWorkouts();
    });
  }

  Map<String, int> _getWorkoutTypeDistribution() {
    final distribution = <String, int>{};
    for (var workout in _workouts) {
      distribution[workout.workoutType] = (distribution[workout.workoutType] ?? 0) + 1;
    }
    return distribution;
  }

  List<FlSpot> _getWorkoutFrequencyData() {
    final now = DateTime.now();
    final data = <FlSpot>[];
    
    for (int i = _selectedDays - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final count = _workouts.where((w) {
        return w.date.year == date.year &&
            w.date.month == date.month &&
            w.date.day == date.day;
      }).length;
      
      data.add(FlSpot((_selectedDays - 1 - i).toDouble(), count.toDouble()));
    }
    
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final thisMonthWorkouts = _getWorkoutsInPeriod(30);
    final lastMonthWorkouts = _getWorkoutsInPeriod(60) - thisMonthWorkouts;
    final changePercentage = lastMonthWorkouts > 0 
        ? ((thisMonthWorkouts - lastMonthWorkouts) / lastMonthWorkouts * 100).toInt()
        : 0;

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
                'Statistics',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildOverviewCard(
                          '📊',
                          'This Month',
                          '$thisMonthWorkouts',
                          changePercentage >= 0 ? '+$changePercentage%' : '$changePercentage%',
                          changePercentage >= 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOverviewCard(
                          '⏱️',
                          'Total Hours',
                          (_user?.totalHours ?? 0).toStringAsFixed(1),
                          'All time',
                          true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOverviewCard(
                          '🔥',
                          'Calories',
                          '${_user?.totalCalories ?? 0}',
                          'Total burned',
                          true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOverviewCard(
                          '🏆',
                          'Best Streak',
                          '${_user?.longestStreak ?? 0}',
                          'Days',
                          true,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Workout Frequency Chart
                  const Text(
                    'Workout Frequency 📈',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Period selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPeriodChip('7 Days', 7),
                      const SizedBox(width: 8),
                      _buildPeriodChip('30 Days', 30),
                      const SizedBox(width: 8),
                      _buildPeriodChip('90 Days', 90),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.cardDecoration(),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textMedium,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _getWorkoutFrequencyData(),
                            isCurved: true,
                            color: AppTheme.primaryOrange,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                        minY: 0,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Workout Type Distribution
                  const Text(
                    'Workout Types 🎯',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildWorkoutTypeDistribution(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String emoji, String label, String value, String subtitle, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isPositive ? AppTheme.successGreen : AppTheme.errorRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, int days) {
    final isSelected = _selectedDays == days;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDays = days;
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

  Widget _buildWorkoutTypeDistribution() {
    final distribution = _getWorkoutTypeDistribution();
    if (distribution.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: AppTheme.cardDecoration(),
        child: const Center(
          child: Text(
            'No workout data available',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textMedium,
            ),
          ),
        ),
      );
    }

    final types = {
      'strength': {'emoji': '🏋️', 'name': 'Strength', 'color': AppTheme.primaryOrange},
      'cardio': {'emoji': '🏃', 'name': 'Cardio', 'color': AppTheme.successGreen},
      'yoga': {'emoji': '🧘', 'name': 'Yoga', 'color': AppTheme.deepBlue},
      'outdoor': {'emoji': '🚴', 'name': 'Outdoor', 'color': AppTheme.warningAmber},
    };

    final total = distribution.values.fold(0, (sum, count) => sum + count);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: distribution.entries.map((entry) {
          final typeInfo = types[entry.key]!;
          final percentage = (entry.value / total * 100).toInt();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      typeInfo['emoji'] as String,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                typeInfo['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${entry.value} workouts ($percentage%)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: entry.value / total,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                typeInfo['color'] as Color,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  int _getWorkoutsInPeriod(int days) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    return _workouts.where((w) => w.date.isAfter(startDate)).length;
  }
}

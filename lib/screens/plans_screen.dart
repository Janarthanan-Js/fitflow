import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final List<Map<String, dynamic>> _presetPlans = [
    {
      'id': 'beginner',
      'name': 'Beginner Starter',
      'emoji': '⭐',
      'description': 'Perfect for fitness newcomers. Build fundamental strength and establish consistent workout habits.',
      'duration': '4 weeks',
      'difficulty': 'Beginner',
      'frequency': '3 days/week',
      'color': AppTheme.successGreen,
    },
    {
      'id': 'muscle_gain',
      'name': 'Muscle Builder',
      'emoji': '💪',
      'description': 'Focused strength training program designed to maximize muscle growth and power.',
      'duration': '8 weeks',
      'difficulty': 'Intermediate',
      'frequency': '4-5 days/week',
      'color': AppTheme.primaryOrange,
    },
    {
      'id': 'fat_loss',
      'name': 'Fat Loss Challenge',
      'emoji': '🔥',
      'description': 'High-intensity workouts combined with cardio to burn maximum calories.',
      'duration': '6 weeks',
      'difficulty': 'Intermediate',
      'frequency': '5 days/week',
      'color': AppTheme.errorRed,
    },
    {
      'id': 'marathon',
      'name': 'Marathon Prep',
      'emoji': '🏃',
      'description': 'Comprehensive running program to prepare you for your first marathon.',
      'duration': '16 weeks',
      'difficulty': 'Advanced',
      'frequency': '5-6 days/week',
      'color': AppTheme.deepBlue,
    },
  ];

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
                'Workout Plans',
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
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.deepBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.deepBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text('💡', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Choose a structured workout plan to stay consistent and achieve your fitness goals faster!',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Featured Plans',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Plans list
                  ..._presetPlans.map((plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPlanCard(plan),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    return Container(
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  plan['color'],
                  plan['color'].withValues(alpha: 0.7),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  plan['emoji'],
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan['difficulty'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    _buildPlanDetail('📅', plan['duration']),
                    const SizedBox(width: 16),
                    _buildPlanDetail('🎯', plan['frequency']),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showPlanDetails(plan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan['color'],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetail(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showPlanDetails(Map<String, dynamic> plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan['emoji'],
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan['name'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                plan['difficulty'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: plan['color'],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'About This Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plan['description'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textDark,
                        height: 1.6,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Plan Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildDetailRow('📅 Duration', plan['duration']),
                    _buildDetailRow('🎯 Frequency', plan['frequency']),
                    _buildDetailRow('⭐ Level', plan['difficulty']),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${plan['name']} activated! 🎉'),
                              backgroundColor: AppTheme.successGreen,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: plan['color'],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Start This Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textMedium,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

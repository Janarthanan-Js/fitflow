import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/user_profile.dart';
import '../models/workout_record.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _user;
  List<Achievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _user = StorageService.getUserProfile();
      _achievements = StorageService.getAllAchievements();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final unlockedAchievements = _achievements.where((a) => a.isUnlocked).length;
    final membershipDays = DateTime.now().difference(_user!.joinDate).inDays;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          _user!.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _user!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _user!.levelEmoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _user!.levelName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '🔥',
                          '${_user!.currentStreak}',
                          'Day Streak',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '💪',
                          '${_user!.totalWorkouts}',
                          'Workouts',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '⏱️',
                          '${_user!.totalHours.toStringAsFixed(0)}h',
                          'Total Hours',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '📅',
                          '$membershipDays',
                          'Days Member',
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Achievements Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Achievements 🏆',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        '$unlockedAchievements/${_achievements.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  _buildAchievementsGrid(),
                  
                  const SizedBox(height: 24),
                  
                  // Settings Section
                  const Text(
                    'Settings ⚙️',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Container(
                    decoration: AppTheme.cardDecoration(),
                    child: Column(
                      children: [
                        _buildSettingTile(
                          Icons.person_outline,
                          'Edit Profile',
                          () {
                            _showEditProfileDialog();
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingTile(
                          Icons.scale_outlined,
                          'Units: ${_user!.preferredUnit.toUpperCase()}',
                          () {
                            _showUnitsDialog();
                          },
                        ),
                        const Divider(height: 1),
                        _buildSettingTile(
                          Icons.info_outline,
                          'About FitFlow',
                          () {
                            _showAboutDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
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
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return InkWell(
          onTap: () => _showAchievementDetails(achievement),
          child: Container(
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? AppTheme.successGreen.withValues(alpha: 0.1)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: achievement.isUnlocked
                    ? AppTheme.successGreen
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                achievement.emoji,
                style: TextStyle(
                  fontSize: 32,
                  color: achievement.isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOrange),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          achievement.isUnlocked ? '🏆 Unlocked!' : '🔒 Locked',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              achievement.emoji,
              style: TextStyle(
                fontSize: 64,
                color: achievement.isUnlocked ? null : Colors.grey,
              ),
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
            if (achievement.isUnlocked && achievement.unlockedDate != null) ...[
              const SizedBox(height: 12),
              Text(
                'Unlocked on ${DateFormat('MMM d, yyyy').format(achievement.unlockedDate!)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMedium,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _user!.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              _user!.name = nameController.text;
              await StorageService.updateUserProfile(_user!);
              setState(() {});
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated!'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showUnitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferred Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Kilograms (kg)'),
              value: 'kg',
              groupValue: _user!.preferredUnit,
              onChanged: (value) async {
                _user!.preferredUnit = value!;
                await StorageService.updateUserProfile(_user!);
                setState(() {});
                if (mounted) Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Pounds (lb)'),
              value: 'lb',
              groupValue: _user!.preferredUnit,
              onChanged: (value) async {
                _user!.preferredUnit = value!;
                await StorageService.updateUserProfile(_user!);
                setState(() {});
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('💪 FitFlow'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Personal Fitness Tracking Companion',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'FitFlow helps you build consistent workout habits, track your progress, and achieve your fitness goals.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

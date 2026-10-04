import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive storage
  await StorageService.init();
  
  // Initialize default achievements
  await StorageService.initializeAchievements();
  
  // Initialize or get user profile
  final user = StorageService.getUserProfile();
  if (kDebugMode) {
    debugPrint('User initialized: ${user?.name}');
  }
  
  runApp(const FitFlowApp());
}

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}

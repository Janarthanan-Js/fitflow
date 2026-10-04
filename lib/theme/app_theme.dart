import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Orange Gradient
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeLight = Color(0xFFFF8E53);
  
  // Supporting Colors
  static const Color deepBlue = Color(0xFF1E3A8A);
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFF34D399);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, primaryOrangeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [successGreen, successGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryOrange,
      secondary: deepBlue,
      surface: cardBackground,
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorRed),
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryOrange,
      unselectedItemColor: textMedium,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textDark),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textMedium),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: textMedium),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textDark),
    ),
  );
  
  // Helper methods for common styles
  static BoxDecoration cardDecoration({Color? color}) {
    return BoxDecoration(
      color: color ?? cardBackground,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static BoxDecoration gradientDecoration(Gradient gradient) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

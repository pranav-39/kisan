import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  static const Color primary = Color(0xFF16A34A);
  static const Color primaryLight = Color(0xFF22C55E);
  static const Color primaryDark = Color(0xFF15803D);
  
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color secondaryLight = Color(0xFF38BDF8);
  static const Color secondaryDark = Color(0xFF0284C7);
  
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  
  static const Color backgroundLight = Color(0xFFF3F4F6);
  static const Color backgroundDark = Color(0xFF1F2937);
  
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF374151);
  
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF4B5563);
  
  static const Color offlineIndicator = Color(0xFFEF4444);
  static const Color onlineIndicator = Color(0xFF22C55E);
  
  static const Color trendUp = Color(0xFF22C55E);
  static const Color trendDown = Color(0xFFEF4444);
  static const Color trendNeutral = Color(0xFF6B7280);
  
  static const Color cropRice = Color(0xFF84CC16);
  static const Color cropWheat = Color(0xFFFBBF24);
  static const Color cropCotton = Color(0xFFF1F5F9);
  static const Color cropTomato = Color(0xFFEF4444);
  static const Color cropPotato = Color(0xFFD97706);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFFFDE68A), Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFCA5A5), Color(0xFFF87171), Color(0xFFEF4444)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

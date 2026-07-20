// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // 🎯 Primary Branding
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF60A5FA);

  // 🎯 Transaction Types (Semantic Colors)
  static const Color income = Color(0xFF10B981); // Success Green
  static const Color expense = Color(0xFFEF4444); // Error Red
  static const Color warning = Color(0xFFF59E0B); // Pending / Alert

  // ☀️ Light Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFF1F5F9);

  // 🌙 Dark Theme Palette (OLED & Slate Friendly)
  static const Color darkBackground = Color(0xFF0F172A); // Dark Navy
  static const Color darkCard = Color(0xFF1E293B); // Dark Slate
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);

  // 🎨 Category Accents (For Pie Charts & Tags)
  static const Color food = Color(0xFFF97316); // Orange
  static const Color travel = Color(0xFF3B82F6); // Blue
  static const Color shopping = Color(0xFFEC4899); // Pink
  static const Color bills = Color(0xFF8B5CF6); // Purple
  static const Color education = Color(0xFF14B8A6); // Teal
  static const Color health = Color(0xFFEF4444); // Red
  static const Color entertainment = Color(0xFFEAB308); // Yellow
  static const Color other = Color(0xFF6B7280); // Grey

  // ✨ Shimmer / Loading Skeleton Colors
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF8FAFC);
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  static const Color shimmerHighlightDark = Color(0xFF334155);
}
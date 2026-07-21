import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;
  static const double p64 = 64.0;
  static const double p80 = 80.0; // <-- ADDED THIS

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0; // <-- ADDED THIS
  static const double radiusButton = 16.0;
  static const double radiusDialog = 20.0;
  static const double radiusCard = 22.0;
  static const double radiusBottomSheet = 28.0;
  static const double radiusCircular = 100.0;

  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 48.0;

  static const double buttonHeight = 54.0;
  static const double inputHeight = 56.0;
  static const double cardElevation = 4.0;

  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: p16,
    vertical: p12,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(p16);
  static const EdgeInsets paddingButton = EdgeInsets.symmetric(
    horizontal: p24,
    vertical: p16,
  );
}
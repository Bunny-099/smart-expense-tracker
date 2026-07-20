import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : AppStrings.requiredField;
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final number = double.tryParse(value.replaceAll(',', ''));
    if (number == null || number <= 0) {
      return AppStrings.invalidAmount;
    }
    return null;
  }
}
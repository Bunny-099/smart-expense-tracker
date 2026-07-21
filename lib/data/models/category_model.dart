import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

enum TransactionType { income, expense }

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'food',
      name: AppStrings.food,
      icon: Icons.restaurant_rounded,
      color: AppColors.food,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'travel',
      name: AppStrings.travel,
      icon: Icons.flight_rounded,
      color: AppColors.travel,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'shopping',
      name: AppStrings.shopping,
      icon: Icons.shopping_bag_rounded,
      color: AppColors.shopping,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'bills',
      name: AppStrings.bills,
      icon: Icons.receipt_long_rounded,
      color: AppColors.bills,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'education',
      name: AppStrings.education,
      icon: Icons.school_rounded,
      color: AppColors.education,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'health',
      name: AppStrings.health,
      icon: Icons.medical_services_rounded,
      color: AppColors.health,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'entertainment',
      name: AppStrings.entertainment,
      icon: Icons.movie_rounded,
      color: AppColors.entertainment,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'other_expense',
      name: AppStrings.other,
      icon: Icons.more_horiz_rounded,
      color: AppColors.other,
      type: TransactionType.expense,
    ),
    CategoryModel(
      id: 'salary',
      name: 'Salary',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.income,
      type: TransactionType.income,
    ),
    CategoryModel(
      id: 'freelance',
      name: 'Freelance',
      icon: Icons.work_rounded,
      color: AppColors.primary,
      type: TransactionType.income,
    ),
    CategoryModel(
      id: 'investment',
      name: 'Investment',
      icon: Icons.trending_up_rounded,
      color: AppColors.education,
      type: TransactionType.income,
    ),
    CategoryModel(
      id: 'other_income',
      name: AppStrings.other,
      icon: Icons.add_circle_outline_rounded,
      color: AppColors.other,
      type: TransactionType.income,
    ),
  ];

  static CategoryModel getById(String id) {
    return categories.firstWhere(
          (cat) => cat.id == id,
      orElse: () => categories.firstWhere((cat) => cat.id == 'other_expense'),
    );
  }

  static CategoryModel getByName(String name) {
    return categories.firstWhere(
          (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      orElse: () => categories.firstWhere((cat) => cat.id == 'other_expense'),
    );
  }

  static List<CategoryModel> getByType(TransactionType type) {
    return categories.where((cat) => cat.type == type).toList();
  }
}
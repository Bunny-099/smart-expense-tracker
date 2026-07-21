import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';

class SpendingChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const SpendingChart({
    super.key,
    required this.transactions,
  });

  List<double> _calculateDailySpending() {
    final now = DateTime.now();
    final List<double> dailyTotals = List.filled(7, 0.0);

    for (final tx in transactions) {
      if (tx.transactionType == TransactionType.expense) {
        final difference = now.difference(tx.date).inDays;
        if (difference >= 0 && difference < 7) {
          final index = 6 - difference;
          dailyTotals[index] += tx.amount;
        }
      }
    }
    return dailyTotals;
  }

  List<String> _getDayLabels() {
    final now = DateTime.now();
    final List<String> labels = [];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      labels.add(weekdays[day.weekday - 1]);
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final dailySpending = _calculateDailySpending();
    final labels = _getDayLabels();
    final maxSpending = dailySpending.fold(0.0, (max, val) => val > max ? val : max);

    return Container(
      padding: const EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Spending',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                Formatters.currency(dailySpending.fold(0.0, (sum, val) => sum + val)),
                style: context.textTheme.titleSmall?.copyWith(
                  color: AppColors.expense,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p24),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final amount = dailySpending[index];
                final factor = maxSpending > 0 ? (amount / maxSpending).clamp(0.05, 1.0) : 0.05;
                final isToday = index == 6;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: factor,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.primary
                                      : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.p8),
                        Text(
                          labels[index],
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday
                                ? AppColors.primary
                                : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
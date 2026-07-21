import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/category_model.dart';

class CategorySummary extends StatelessWidget {
  final Map<CategoryModel, double> expenseByCategory;
  final double totalExpense;

  const CategorySummary({
    super.key,
    required this.expenseByCategory,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    if (expenseByCategory.isEmpty || totalExpense <= 0) {
      return const SizedBox.shrink();
    }

    final sortedEntries = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
          Text(
            'Spending by Category',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.p16),
          ...sortedEntries.map((entry) {
            final category = entry.key;
            final amount = entry.value;
            final percentage = (amount / totalExpense).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.p16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSizes.p8),
                        decoration: BoxDecoration(
                          color: category.color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category.icon,
                          color: category.color,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p12),
                      Expanded(
                        child: Text(
                          category.name,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        Formatters.currency(amount),
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p8),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '${(percentage * 100).toStringAsFixed(0)}%',
                          textAlign: TextAlign.end,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      valueColor: AlwaysStoppedAnimation<Color>(category.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/category_model.dart';

class CategorySelector extends StatelessWidget {
  final TransactionType transactionType;
  final String? selectedCategoryId;
  final ValueChanged<CategoryModel> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.transactionType,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final categories = CategoryModel.categories
        .where((cat) => cat.type == transactionType)
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSizes.p12,
        mainAxisSpacing: AppSizes.p12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category.id == selectedCategoryId;
        final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
        final borderColor = isSelected
            ? category.color
            : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onCategorySelected(category),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppSizes.p8),
              decoration: BoxDecoration(
                color: isSelected
                    ? category.color.withValues(alpha: 0.15)
                    : cardColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(
                  color: borderColor,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p8),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p8),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? category.color
                          : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
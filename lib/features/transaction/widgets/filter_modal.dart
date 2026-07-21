import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/category_model.dart';
import '../providers/filter_provider.dart';

class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterModal(),
    );
  }

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  TransactionType? _selectedType;
  String? _selectedCategoryId;
  late SortOption _sortOption;

  @override
  void initState() {
    super.initState();
    final filterState = ref.read(filterProvider);
    _selectedType = filterState.selectedType;
    _selectedCategoryId = filterState.selectedCategoryId;
    _sortOption = filterState.sortOption;
  }

  void _applyFilters() {
    final notifier = ref.read(filterProvider.notifier);
    notifier.setType(_selectedType);
    notifier.setCategory(_selectedCategoryId);
    notifier.setSortOption(_sortOption);
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    ref.read(filterProvider.notifier).resetFilters();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final availableCategories = CategoryModel.categories.where((cat) {
      if (_selectedType == null) return true;
      return cat.type == _selectedType;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLarge),
          topRight: Radius.circular(AppSizes.radiusLarge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter & Sort',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p16),
            Text(
              'Transaction Type',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            Row(
              children: [
                _buildTypeChip('All', null, isDark, borderColor),
                const SizedBox(width: AppSizes.p8),
                _buildTypeChip('Income', TransactionType.income, isDark, borderColor),
                const SizedBox(width: AppSizes.p8),
                _buildTypeChip('Expense', TransactionType.expense, isDark, borderColor),
              ],
            ),
            const SizedBox(height: AppSizes.p20),
            Text(
              'Sort By',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            Wrap(
              spacing: AppSizes.p8,
              runSpacing: AppSizes.p8,
              children: [
                _buildSortChip('Newest First', SortOption.newestFirst, isDark, borderColor),
                _buildSortChip('Oldest First', SortOption.oldestFirst, isDark, borderColor),
                _buildSortChip('Highest Amount', SortOption.highestAmount, isDark, borderColor),
                _buildSortChip('Lowest Amount', SortOption.lowestAmount, isDark, borderColor),
              ],
            ),
            const SizedBox(height: AppSizes.p20),
            Text(
              'Category',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip(null, 'All Categories', null, isDark, borderColor),
                  ...availableCategories.map((cat) => Padding(
                    padding: const EdgeInsets.only(left: AppSizes.p8),
                    child: _buildCategoryChip(cat.id, cat.name, cat.color, isDark, borderColor),
                  )),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Reset',
                    isOutlined: true,
                    onPressed: _resetFilters,
                  ),
                ),
                const SizedBox(width: AppSizes.p12),
                Expanded(
                  child: AppButton(
                    label: 'Apply',
                    onPressed: _applyFilters,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
      String label,
      TransactionType? type,
      bool isDark,
      Color borderColor,
      ) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedType = type;
            if (_selectedCategoryId != null && type != null) {
              final catExists = CategoryModel.categories.any(
                    (c) => c.id == _selectedCategoryId && c.type == type,
              );
              if (!catExists) {
                _selectedCategoryId = null;
              }
            }
          });
        },
        selectedColor: AppColors.primary,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          side: BorderSide(
            color: isSelected ? AppColors.primary : borderColor,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildSortChip(
      String label,
      SortOption option,
      bool isDark,
      Color borderColor,
      ) {
    final isSelected = _sortOption == option;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _sortOption = option;
        });
      },
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: isSelected ? AppColors.primary : borderColor,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildCategoryChip(
      String? id,
      String label,
      Color? color,
      bool isDark,
      Color borderColor,
      ) {
    final isSelected = _selectedCategoryId == id;
    final chipColor = color ?? AppColors.primary;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedCategoryId = id;
        });
      },
      selectedColor: chipColor,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: isSelected ? chipColor : borderColor,
        ),
      ),
      showCheckmark: false,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';
import 'category_selector.dart';

class TransactionForm extends StatefulWidget {
  final TransactionModel? initialTransaction;
  final TransactionType? initialType;
  final Function(
      String title,
      double amount,
      TransactionType type,
      String categoryId,
      DateTime date,
      String? description,
      ) onSubmit;
  final bool isLoading;
  final String submitButtonText;

  const TransactionForm({
    super.key,
    this.initialTransaction,
    this.initialType,
    required this.onSubmit,
    this.isLoading = false,
    this.submitButtonText = AppStrings.saveTransaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  late TransactionType _selectedType;
  String? _selectedCategoryId;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;

    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toStringAsFixed(2) : '',
    );
    _descriptionController = TextEditingController(text: tx?.description ?? '');

    _selectedType = tx?.transactionType ??
        widget.initialType ??
        TransactionType.expense;
    _selectedCategoryId = tx?.categoryId;
    _selectedDate = tx?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleTypeChange(TransactionType newType) {
    if (_selectedType == newType) return;
    setState(() {
      _selectedType = newType;
      _selectedCategoryId = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: context.theme.copyWith(
            colorScheme: context.colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a category'),
          backgroundColor: AppColors.expense,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),
      );
      return;
    }

    final amountText = _amountController.text.replaceAll(',', '').trim();
    final parsedAmount = double.tryParse(amountText) ?? 0.0;

    widget.onSubmit(
      _titleController.text.trim(),
      parsedAmount,
      _selectedType,
      _selectedCategoryId!,
      _selectedDate,
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.p4),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusButton),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                _buildTypeTab(
                  label: AppStrings.expense,
                  type: TransactionType.expense,
                  activeColor: AppColors.expense,
                  isDark: isDark,
                ),
                _buildTypeTab(
                  label: AppStrings.income,
                  type: TransactionType.income,
                  activeColor: AppColors.income,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.p24),
          AppTextField(
            controller: _titleController,
            labelText: AppStrings.title,
            hintText: AppStrings.titleHint,
            textInputAction: TextInputAction.next,
            validator: Validators.validateTitle,
            prefixIcon: const Icon(Icons.title_rounded, size: 20),
          ),
          const SizedBox(height: AppSizes.p20),
          AppTextField(
            controller: _amountController,
            labelText: AppStrings.amount,
            hintText: AppStrings.amountHint,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            validator: Validators.validateAmount,
            prefixIcon: const Icon(Icons.currency_rupee_rounded, size: 20),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: AppSizes.p20),
          Text(
            AppStrings.date,
            style: context.textTheme.labelLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.p8),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p16,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: AppSizes.p12),
                  Text(
                    Formatters.date(_selectedDate),
                    style: context.textTheme.bodyLarge?.copyWith(fontSize: 15),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.p24),
          Text(
            AppStrings.category,
            style: context.textTheme.labelLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.p12),
          CategorySelector(
            transactionType: _selectedType,
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategoryId = category.id;
              });
            },
          ),
          const SizedBox(height: AppSizes.p24),
          AppTextField(
            controller: _descriptionController,
            labelText: AppStrings.description,
            hintText: AppStrings.descriptionHint,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: Icon(Icons.notes_rounded, size: 20),
            ),
          ),
          const SizedBox(height: AppSizes.p32),
          AppButton(
            label: widget.submitButtonText,
            onPressed: _submitForm,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: AppSizes.p24),
        ],
      ),
    );
  }

  Widget _buildTypeTab({
    required String label,
    required TransactionType type,
    required Color activeColor,
    required bool isDark,
  }) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTypeChange(type),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
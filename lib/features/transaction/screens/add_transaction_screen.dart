import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_form.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionType? initialType;

  const AddTransactionScreen({
    super.key,
    this.initialType,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit(
      String title,
      double amount,
      TransactionType type,
      String categoryId,
      DateTime date,
      String? description,
      ) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      type: type == TransactionType.income ? 'income' : 'expense',
      categoryId: categoryId,
      date: date,
      description: description,
    );

    final success = await ref
        .read(transactionProvider.notifier)
        .addTransaction(newTransaction);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      AppSnackbar.showSuccess(context, AppStrings.successSaved);
      Navigator.of(context).pop();
    } else {
      final errorMsg =
          ref.read(transactionProvider).error ?? AppStrings.errorTitle;
      AppSnackbar.showError(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.addTransaction,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.p20),
          child: TransactionForm(
            initialType: widget.initialType,
            onSubmit: _handleSubmit,
            isLoading: _isSubmitting,
            submitButtonText: AppStrings.saveTransaction,
          ),
        ),
      ),
    );
  }
}
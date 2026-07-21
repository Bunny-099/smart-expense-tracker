import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_form.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  bool _isSubmitting = false;
  bool _isDeleting = false;

  Future<void> _handleUpdate(
      String title,
      double amount,
      TransactionType type,
      String categoryId,
      DateTime date,
      String? description,
      ) async {
    if (_isSubmitting || _isDeleting) return;

    setState(() {
      _isSubmitting = true;
    });

    final updatedTransaction = widget.transaction.copyWith(
      title: title,
      amount: amount,
      type: type == TransactionType.income ? 'income' : 'expense',
      categoryId: categoryId,
      date: date,
      description: description,
    );

    final success = await ref
        .read(transactionProvider.notifier)
        .updateTransaction(updatedTransaction);

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

  Future<void> _confirmDelete() async {
    if (_isSubmitting || _isDeleting) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = context.isDarkMode;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusDialog),
          ),
          title: Text(
            AppStrings.deleteConfirmationTitle,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            AppStrings.deleteConfirmationSub,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.expense,
              ),
              child: const Text(
                AppStrings.delete,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    setState(() {
      _isDeleting = true;
    });

    final success = await ref
        .read(transactionProvider.notifier)
        .deleteTransaction(widget.transaction.id);

    if (!mounted) return;

    setState(() {
      _isDeleting = false;
    });

    if (success) {
      AppSnackbar.showSuccess(context, AppStrings.successDeleted);
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
          AppStrings.editTransaction,
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
        actions: [
          if (_isDeleting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.expense),
                  ),
                ),
              ),
            )
          else
            IconButton(
              onPressed: _confirmDelete,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.expense,
                size: 24,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.p20),
          child: TransactionForm(
            initialTransaction: widget.transaction,
            onSubmit: _handleUpdate,
            isLoading: _isSubmitting,
            submitButtonText: AppStrings.updateTransaction,
          ),
        ),
      ),
    );
  }
}
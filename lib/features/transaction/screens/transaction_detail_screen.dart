import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import 'edit_transaction_screen.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  bool _isDeleting = false;

  Future<void> _confirmDelete(TransactionModel transaction) async {
    if (_isDeleting) return;

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
        .deleteTransaction(transaction.id);

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

  void _navigateToEdit(TransactionModel transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final transactionState = ref.watch(transactionProvider);
    final transaction = transactionState.transactions.where(
          (t) => t.id == widget.transactionId,
    ).firstOrNull;

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(
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
        body: Center(
          child: Text(
            'Transaction not found or has been deleted.',
            style: context.textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    final isIncome = transaction.transactionType == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';
    final category = transaction.category;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.transactionDetails,
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
          IconButton(
            onPressed: () => _navigateToEdit(transaction),
            icon: Icon(
              Icons.edit_outlined,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              size: 22,
            ),
          ),
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
              onPressed: () => _confirmDelete(transaction),
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),
                    Text(
                      transaction.title,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.p8),
                    Text(
                      '$prefix ${Formatters.currency(transaction.amount)}',
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p12,
                        vertical: AppSizes.p4,
                      ),
                      decoration: BoxDecoration(
                        color: amountColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCircular,
                        ),
                      ),
                      child: Text(
                        isIncome ? AppStrings.income : AppStrings.expense,
                        style: TextStyle(
                          color: amountColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.p20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      label: AppStrings.category,
                      value: category.name,
                      icon: category.icon,
                      iconColor: category.color,
                      isDark: isDark,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
                      child: Divider(),
                    ),
                    _buildDetailRow(
                      context,
                      label: AppStrings.date,
                      value: Formatters.date(transaction.date),
                      icon: Icons.calendar_today_rounded,
                      iconColor: AppColors.primary,
                      isDark: isDark,
                    ),
                    if (transaction.description != null &&
                        transaction.description!.trim().isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
                        child: Divider(),
                      ),
                      _buildDetailRow(
                        context,
                        label: AppStrings.description,
                        value: transaction.description!,
                        icon: Icons.notes_rounded,
                        iconColor: AppColors.warning,
                        isDark: isDark,
                        isMultiLine: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: AppStrings.editTransaction,
                      isOutlined: true,
                      onPressed: () => _navigateToEdit(transaction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
        required Color iconColor,
        required bool isDark,
        bool isMultiLine = false,
      }) {
    return Row(
      crossAxisAlignment:
      isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.p8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: AppSizes.p12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
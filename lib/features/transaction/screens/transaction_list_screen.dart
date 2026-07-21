import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../data/models/transaction_model.dart';
import '../providers/filter_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/filter_modal.dart';
import '../widgets/search_bar.dart';
import '../widgets/transaction_list.dart';

class TransactionListScreen extends ConsumerWidget {
  final ValueChanged<TransactionModel>? onTransactionTap;
  final VoidCallback? onAddTransaction;

  const TransactionListScreen({
    super.key,
    this.onTransactionTap,
    this.onAddTransaction,
  });

  void _handleDelete(BuildContext context, WidgetRef ref, TransactionModel tx) {
    ref.read(transactionProvider.notifier).deleteTransaction(tx.id);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${tx.title} deleted',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.darkCard,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: () {
            ref.read(transactionProvider.notifier).addTransaction(tx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final filterState = ref.watch(filterProvider);
    final isDark = context.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.p20,
                AppSizes.p16,
                AppSizes.p20,
                AppSizes.p8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => FilterModal.show(context),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMedium,
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.tune_rounded,
                          size: 22,
                        ),
                      ),
                      if (filterState.hasActiveFilters)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p20,
                vertical: AppSizes.p8,
              ),
              child: TransactionSearchBar(),
            ),
            Expanded(
              child: _buildBody(context, ref, filteredTransactions, filterState),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTransaction,
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      WidgetRef ref,
      List<TransactionModel> transactions,
      FilterState filterState,
      ) {
    if (transactions.isEmpty) {
      if (filterState.hasActiveFilters) {
        return EmptyStateWidget(
          icon: Icons.filter_list_off_rounded,
          title: 'No Matching Transactions',
          subtitle: 'Try adjusting or resetting your search and filter criteria.',
          buttonText: 'Reset Filters',
          onButtonPressed: () {
            ref.read(filterProvider.notifier).resetFilters();
          },
        );
      }

      return EmptyStateWidget(
        icon: Icons.receipt_long_rounded,
        title: 'No Transactions Yet',
        subtitle: 'Start tracking your spending by adding your first transaction.',
        buttonText: 'Add Transaction',
        onButtonPressed: onAddTransaction,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
      child: TransactionList(
        transactions: transactions,
        physics: const BouncingScrollPhysics(),
        onTap: onTransactionTap != null ? (tx) => onTransactionTap!(tx) : null,
        onDelete: (tx) => _handleDelete(context, ref, tx),
      ),
    );
  }
}
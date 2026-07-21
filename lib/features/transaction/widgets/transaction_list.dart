import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/transaction_model.dart';
import 'transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final ValueChanged<TransactionModel>? onTap;
  final ValueChanged<TransactionModel>? onDelete;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const TransactionList({
    super.key,
    required this.transactions,
    this.onTap,
    this.onDelete,
    this.physics,
    this.shrinkWrap = false,
  });

  Map<String, List<TransactionModel>> _groupTransactionsByDate() {
    final grouped = <String, List<TransactionModel>>{};
    for (final tx in transactions) {
      final dateKey = Formatters.date(tx.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(tx);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final groupedTransactions = _groupTransactionsByDate();
    final dateKeys = groupedTransactions.keys.toList();

    return ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: const EdgeInsets.only(bottom: AppSizes.p24),
      itemCount: dateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = dateKeys[index];
        final dayTransactions = groupedTransactions[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.p4,
                top: AppSizes.p16,
                bottom: AppSizes.p8,
              ),
              child: Text(
                dateKey,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            ...dayTransactions.map((tx) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.p12),
                child: Dismissible(
                  key: ValueKey(tx.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSizes.p20),
                    decoration: BoxDecoration(
                      color: AppColors.expense,
                      borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  onDismissed: (_) {
                    if (onDelete != null) {
                      onDelete!(tx);
                    }
                  },
                  child: TransactionCard(
                    transaction: tx,
                    onTap: onTap != null ? () => onTap!(tx) : null,
                    onDelete: onDelete != null ? () => onDelete!(tx) : null,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
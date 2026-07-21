import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_textfield.dart';
import '../providers/exchange_provider.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState
    extends ConsumerState<CurrencyConverterScreen> {
  late final TextEditingController _amountController;
  final List<String> _popularCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'INR',
    'JPY',
    'CAD',
    'AUD',
    'SGD',
    'AED',
    'CNY',
  ];

  @override
  void initState() {
    super.initState();
    final initialAmount = ref.read(exchangeProvider).inputAmount;
    _amountController = TextEditingController(
      text: initialAmount == 0 ? '' : initialAmount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    final cleanValue = value.replaceAll(',', '').trim();
    final parsedAmount = double.tryParse(cleanValue) ?? 0.0;
    ref.read(exchangeProvider.notifier).updateInputAmount(parsedAmount);
  }

  void _showCurrencyPicker({required bool isBaseCurrency}) {
    final isDark = context.isDarkMode;
    final currentState = ref.read(exchangeProvider);
    final selectedCurrency = isBaseCurrency
        ? currentState.baseCurrency
        : currentState.targetCurrency;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusBottomSheet),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.p20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBaseCurrency ? 'Select Base Currency' : 'Select Target Currency',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.p16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _popularCurrencies.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final currency = _popularCurrencies[index];
                      final isSelected = currency == selectedCurrency;

                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (isBaseCurrency) {
                            ref
                                .read(exchangeProvider.notifier)
                                .fetchRates(base: currency);
                          } else {
                            ref
                                .read(exchangeProvider.notifier)
                                .updateTargetCurrency(currency);
                          }
                        },
                        title: Text(
                          currency,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final state = ref.watch(exchangeProvider);
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.currencyConverter,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(exchangeProvider.notifier).fetchRates(
                base: state.baseCurrency,
              );
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading && state.exchangeRate == null
            ? const AppLoader()
            : state.error != null && state.exchangeRate == null
            ? _buildErrorView(context, state.error!)
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.liveRates,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.p16),
              Container(
                padding: const EdgeInsets.all(AppSizes.p20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                  BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.from,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextField(
                            controller: _amountController,
                            hintText: '0.00',
                            keyboardType:
                            const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: _onAmountChanged,
                          ),
                        ),
                        const SizedBox(width: AppSizes.p12),
                        Expanded(
                          flex: 1,
                          child: _buildCurrencySelector(
                            currency: state.baseCurrency,
                            onTap: () => _showCurrencyPicker(
                              isBaseCurrency: true,
                            ),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.p16,
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      ref
                          .read(exchangeProvider.notifier)
                          .swapCurrencies();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.all(AppSizes.p12),
                    ),
                    icon: const Icon(
                      Icons.swap_vert_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSizes.p20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius:
                  BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.to,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: AppSizes.inputHeight,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p16,
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkBackground
                                  : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMedium,
                              ),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              Formatters.currency(
                                state.convertedAmount,
                                symbol: '',
                              ).trim(),
                              style: context.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.income,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.p12),
                        Expanded(
                          flex: 1,
                          child: _buildCurrencySelector(
                            currency: state.targetCurrency,
                            onTap: () => _showCurrencyPicker(
                              isBaseCurrency: false,
                            ),
                            isDark: isDark,
                            borderColor: borderColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p24),
              if (state.exchangeRate != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.p16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusMedium,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '1 ${state.baseCurrency} = ${state.exchangeRate!.getRate(state.targetCurrency).toStringAsFixed(4)} ${state.targetCurrency}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (state.exchangeRate!.timeLastUpdateUtc !=
                          null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Updated: ${state.exchangeRate!.timeLastUpdateUtc!}',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencySelector({
    required String currency,
    required VoidCallback onTap,
    required bool isDark,
    required Color borderColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        height: AppSizes.inputHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currency,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: AppColors.expense,
            ),
            const SizedBox(height: AppSizes.p16),
            Text(
              AppStrings.errorTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            SizedBox(
              width: 180,
              child: AppButton(
                label: AppStrings.retry,
                onPressed: () {
                  ref
                      .read(exchangeProvider.notifier)
                      .fetchRates(base: ref.read(exchangeProvider).baseCurrency);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
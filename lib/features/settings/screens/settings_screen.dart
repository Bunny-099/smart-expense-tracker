import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../transaction/providers/transaction_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = context.isDarkMode;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusDialog),
          ),
          title: Text(
            'Clear All Data?',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'This will permanently delete all your recorded transactions from local storage. This action cannot be undone.',
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
                'Clear All',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (shouldClear == true && context.mounted) {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.clearAll();
      await ref.read(transactionProvider.notifier).loadTransactions();
      if (context.mounted) {
        AppSnackbar.showSuccess(context, 'All transactions cleared successfully');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final currentTheme = ref.watch(themeProvider);
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.settings,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.p12),
              Container(
                padding: const EdgeInsets.all(AppSizes.p8),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildThemeTile(
                      context,
                      ref,
                      title: AppStrings.systemDefault,
                      icon: Icons.brightness_auto_rounded,
                      mode: ThemeMode.system,
                      currentMode: currentTheme,
                      isDark: isDark,
                    ),
                    const Divider(),
                    _buildThemeTile(
                      context,
                      ref,
                      title: AppStrings.lightMode,
                      icon: Icons.light_mode_rounded,
                      mode: ThemeMode.light,
                      currentMode: currentTheme,
                      isDark: isDark,
                    ),
                    const Divider(),
                    _buildThemeTile(
                      context,
                      ref,
                      title: AppStrings.darkMode,
                      icon: Icons.dark_mode_rounded,
                      mode: ThemeMode.dark,
                      currentMode: currentTheme,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.p24),
              Text(
                'Data Management',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.p12),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: ListTile(
                  onTap: () => _confirmClearData(context, ref),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16,
                    vertical: AppSizes.p4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(AppSizes.p8),
                    decoration: BoxDecoration(
                      color: AppColors.expense.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_sweep_rounded,
                      color: AppColors.expense,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Clear All Transactions',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.expense,
                    ),
                  ),
                  subtitle: Text(
                    'Reset your wallet history and local database',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.p24),
              Text(
                'About App',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.p12),
              Container(
                padding: const EdgeInsets.all(AppSizes.p20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Version 1.0.0+1 • Production Demo',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeTile(
      BuildContext context,
      WidgetRef ref, {
        required String title,
        required IconData icon,
        required ThemeMode mode,
        required ThemeMode currentMode,
        required bool isDark,
      }) {
    final isSelected = currentMode == mode;

    return ListTile(
      onTap: () {
        ref.read(themeProvider.notifier).setThemeMode(mode);
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: 2,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.p8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : (isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? AppColors.primary
              : (isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
        size: 22,
      )
          : null,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/utils/extensions.dart';
import '../data/models/transaction_model.dart';
import '../features/currency/screens/currency_converter_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/transaction/screens/add_transaction_screen.dart';
import '../features/transaction/screens/edit_transaction_screen.dart';
import '../features/transaction/screens/transaction_detail_screen.dart';
import '../features/transaction/screens/transaction_list_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => DashboardScreen(
                  onAddTransaction: () => context.push('/add-transaction'),
                  onViewAllTransactions: () => context.go('/transactions'),
                  onTransactionTap: (id) => context.push('/transaction/$id'),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => TransactionListScreen(
                  onAddTransaction: () => context.push('/add-transaction'),
                  onTransactionTap: (tx) => context.push('/transaction/${tx.id}'),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/currency',
                builder: (context, state) => const CurrencyConverterScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddTransactionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/edit-transaction',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return CustomTransitionPage(
            key: state.pageKey,
            child: EditTransactionScreen(transaction: transaction),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation)),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/transaction/:id',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: TransactionDetailScreen(transactionId: id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation)),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-transaction'),
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: cardColor,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              context,
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: navigationShell.currentIndex == 0,
            ),
            _buildNavItem(
              context,
              index: 1,
              icon: Icons.receipt_long_rounded,
              label: 'Transactions',
              isSelected: navigationShell.currentIndex == 1,
            ),
            const SizedBox(width: 48),
            _buildNavItem(
              context,
              index: 2,
              icon: Icons.currency_exchange_rounded,
              label: 'Currency',
              isSelected: navigationShell.currentIndex == 2,
            ),
            _buildNavItem(
              context,
              index: 3,
              icon: Icons.settings_rounded,
              label: 'Settings',
              isSelected: navigationShell.currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required int index,
        required IconData icon,
        required String label,
        required bool isSelected,
      }) {
    final isDark = context.isDarkMode;
    final activeColor = AppColors.primary;
    final inactiveColor =
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Expanded(
      child: InkWell(
        onTap: () => _onTap(index),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
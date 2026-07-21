import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../providers/search_provider.dart';

class TransactionSearchBar extends ConsumerStatefulWidget {
  final String? hintText;

  const TransactionSearchBar({
    super.key,
    this.hintText = 'Search by title or category...',
  });

  @override
  ConsumerState<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends ConsumerState<TransactionSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clearQuery();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final query = ref.watch(searchQueryProvider);

    if (_controller.text != query) {
      _controller.text = query;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return TextField(
      controller: _controller,
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).updateQuery(value);
      },
      style: context.textTheme.bodyMedium?.copyWith(
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          fontSize: 15,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          size: 22,
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(
          onPressed: _onClear,
          icon: Icon(
            Icons.clear_rounded,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            size: 20,
          ),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
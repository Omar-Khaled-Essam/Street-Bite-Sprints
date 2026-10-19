import 'package:flutter/material.dart';
import 'package:streetbrite/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';

class StreetBiteNavBar extends StatelessWidget {
  const StreetBiteNavBar({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: onChanged,
      indicatorColor: Colors.transparent,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.grey.shade500),
          selectedIcon: const Icon(Icons.home, color: AppColors.primary),
          label: l10n.home,
        ),
        NavigationDestination(
          icon: Icon(Icons.search, color: Colors.grey.shade500),
          selectedIcon: const Icon(Icons.search, color: AppColors.primary),
          label: l10n.browse,
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined, color: Colors.grey.shade500),
          selectedIcon: const Icon(Icons.receipt_long, color: AppColors.primary),
          label: l10n.orders,
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.grey.shade500),
          selectedIcon: const Icon(Icons.person, color: AppColors.primary),
          label: l10n.profile,
        ),
      ],
    );
  }
}

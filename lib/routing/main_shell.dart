import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travel_map/shared/theme/app_colors.dart';
import 'package:travel_map/shared/theme/app_typography.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.6))),
        ),
        padding: const EdgeInsets.only(top: 6, bottom: 20, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              index: 0,
              label: 'Tin tức',
              icon: LucideIcons.newspaper,
            ),
            _buildTabItem(
              index: 1,
              label: 'Gian hàng',
              icon: LucideIcons.shoppingBag,
            ),
            _buildTabItem(
              index: 2,
              label: 'Bản đồ',
              icon: LucideIcons.map,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isActive = navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(16), // rounded-2xl
            ),
            child: Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.primaryForeground : AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.s10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primary : AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}


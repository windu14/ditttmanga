import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset('assets/icons/home.svg', colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
            selectedIcon: SvgPicture.asset('assets/icons/home.svg', colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SvgPicture.asset('assets/icons/search.svg', colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
            selectedIcon: SvgPicture.asset('assets/icons/search.svg', colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
            label: 'Search',
          ),
          NavigationDestination(
            icon: SvgPicture.asset('assets/icons/info.svg', colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn)),
            selectedIcon: SvgPicture.asset('assets/icons/info.svg', colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});
  final Widget child;

  static const List<_NavItem> _navItems = [
    _NavItem(
      label: 'Shalat',
      icon: Icons.access_time_rounded,
      activeIcon: Icons.access_time_filled_rounded,
      path: '/',
    ),
    _NavItem(
      label: 'Kalender',
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
      path: '/calendar',
    ),
    _NavItem(
      label: 'Al-Qur\'an',
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      path: '/quran',
    ),
    _NavItem(
      label: 'Berita',
      icon: Icons.newspaper_outlined,
      activeIcon: Icons.newspaper_rounded,
      path: '/news',
    ),
    _NavItem(
      label: 'Qibla',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      path: '/qibla',
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].path)) {
        // exact match for home
        if (_navItems[i].path == '/' && location != '/') continue;
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          border: const Border(
            top: BorderSide(color: AppColors.darkBorder, width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final isActive = i == idx;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.go(item.path),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: isActive
                              ? BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                )
                              : null,
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            size: 22,
                            color: isActive
                                ? AppColors.gold
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isActive
                                ? AppColors.gold
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
}

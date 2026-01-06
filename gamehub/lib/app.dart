import 'package:flutter/material.dart';
import 'ui/home/home_page.dart';
import 'ui/browse/browser_page.dart';
import 'package:gamehub/ui/lib/library.dart';
import 'ui/user/profile.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      const BrowserPage(),
      const LibraryPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0E0E0E) : const Color(0xFFF6F7FB);
    final surfaceColor = isDark ? const Color(0xFF141414) : Colors.white;
    final borderColor = isDark
        ? Colors.white12
        : Colors.black.withOpacity(0.08);
    final accentColor = const Color(0xFF7C4DFF);
    final inactiveColor = isDark
        ? const Color(0xFF8E8E8E)
        : const Color(0xFF6B6B6B);

    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(top: BorderSide(color: borderColor, width: 0.6)),
        ),
        child: Row(
          children: [
            _navItem(
              index: 0,
              icon: Icons.gamepad_outlined,
              activeIcon: Icons.gamepad,
              label: 'Home',
              accentColor: accentColor,
              inactiveColor: inactiveColor,
            ),
            _navItem(
              index: 1,
              icon: Icons.search_rounded,
              activeIcon: Icons.search_rounded,
              label: 'Search',
              accentColor: accentColor,
              inactiveColor: inactiveColor,
            ),
            _navItem(
              index: 2,
              icon: Icons.bookmarks_outlined,
              activeIcon: Icons.bookmarks_rounded,
              label: 'Library',
              accentColor: accentColor,
              inactiveColor: inactiveColor,
            ),
            _navItem(
              index: 3,
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
              accentColor: accentColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color accentColor,
    required Color inactiveColor,
  }) {
    final selected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              height: 3,
              width: selected ? 26 : 0,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: accentColor,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: accentColor.withOpacity(0.6),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: selected ? 1.15 : 1.0,
              child: Icon(
                selected ? activeIcon : icon,
                size: 26,
                color: selected ? accentColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0.55,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.3,
                  color: selected ? accentColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

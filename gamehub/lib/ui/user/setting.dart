import 'package:flutter/material.dart';
import 'dart:ui';
import '../auth/welcome_page.dart';
import '../../util/theme_manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0D12)
          : const Color(0xFFF8F9FF),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(isDark ? 0.12 : 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent.withOpacity(isDark ? 0.12 : 0.08),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: textColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _buildGroupTitle("PREFERENCES"),
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: ThemeManager.themeNotifier,
                        builder: (context, currentMode, _) {
                          final isDarkModeActive =
                              currentMode == ThemeMode.dark;
                          return _buildToggleItem(
                            context,
                            icon: Icons.dark_mode_rounded,
                            title: "Dark Mode",
                            value: isDarkModeActive,
                            onChanged: ThemeManager.toggleTheme,
                          );
                        },
                      ),
                      _buildToggleItem(
                        context,
                        icon: Icons.notifications_active_rounded,
                        title: "Notifications",
                        value: true,
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 24),
                      _buildGroupTitle("APP INFO"),
                      _buildPlainItem(
                        context,
                        icon: Icons.language_rounded,
                        title: "Language",
                        trailing: "English",
                      ),
                      _buildPlainItem(
                        context,
                        icon: Icons.verified_user_rounded,
                        title: "Version",
                        trailing: "1.0.0",
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WelcomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout_rounded, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }

  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.blueAccent,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
          activeTrackColor: Colors.blueAccent.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildPlainItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: trailing != null
            ? Text(
                trailing,
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              )
            : Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: textColor.withOpacity(0.3),
              ),
        onTap: () {},
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.logout, color: Color(0xFFE53935)),
          SizedBox(width: 8),
          Text('Sign Out?'),
        ]),
        content: const Text(
          'Are you sure you want to sign out of AquaMonitor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out')),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = WaterStationApp.of(context)?.isDarkMode ?? false;
    final bgColor = isDark
      ? const Color(0xFF0A0E1A)
      : const Color(0xFFF8FAFE);
    final cardColor = isDark
      ? const Color(0xFF111827)
      : Colors.white;
    final textColor = isDark
      ? Colors.white
      : const Color(0xFF1A1A2E);
    final subTextColor = isDark
      ? Colors.grey.shade400
      : Colors.grey.shade500;

    final name = _user?.displayName ?? 'Station Owner';
    final email = _user?.email ?? 'No email';
    final initials = name.isNotEmpty
      ? name.trim().split(' ').map((e) => e[0]).take(2)
          .join().toUpperCase()
      : 'A';

    // Station stats from AppState
    final totalRefills = AppState.history
      .where((r) => r['action'] == 'Refill').length;
    final totalDrains = AppState.history
      .where((r) => r['action'] == 'Drain').length;
    final totalAlerts = AppState.alerts.length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Text('Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0077B6))),
              Text('Manage your account & preferences',
                style: TextStyle(
                  fontSize: 13,
                  color: subTextColor)),
              const SizedBox(height: 24),

              // Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF023E8A), Color(0xFF0077B6),
                             Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0077B6).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(children: [
                  Row(children: [
                    // Avatar
                    Container(
                      width: 68, height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2),
                      ),
                      child: Center(
                        child: Text(initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Station Owner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B894)
                                .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(children: [
                              Container(
                                width: 6, height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00B894),
                                  shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                              const Text('Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        ]),
                      ],
                    )),
                  ]),
                  const SizedBox(height: 20),

                  // Stats row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(children: [
                      Expanded(child: _StatItem2(
                        label: 'Refills',
                        value: '$totalRefills',
                        icon: Icons.water_drop)),
                      Container(
                        width: 1, height: 40,
                        color: Colors.white.withOpacity(0.2)),
                      Expanded(child: _StatItem2(
                        label: 'Drains',
                        value: '$totalDrains',
                        icon: Icons.water_drop_outlined)),
                      Container(
                        width: 1, height: 40,
                        color: Colors.white.withOpacity(0.2)),
                      Expanded(child: _StatItem2(
                        label: 'Alerts',
                        value: '$totalAlerts',
                        icon: Icons.notifications_outlined)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              // Account section
              _SectionLabel('Account', subTextColor),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10),
                  ],
                ),
                child: Column(children: [
                  _MenuItem(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    subtitle: 'Update your account password',
                    color: const Color(0xFF0077B6),
                    textColor: textColor,
                    subColor: subTextColor,
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen())),
                  ),
                  Divider(height: 1,
                    color: Colors.grey.withOpacity(0.1)),
                  _MenuItem(
                    icon: Icons.info_outline,
                    label: 'About the App',
                    subtitle: 'Version, features and developer info',
                    color: const Color(0xFF00B894),
                    textColor: textColor,
                    subColor: subTextColor,
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen())),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              // Preferences section
              _SectionLabel('Preferences', subTextColor),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: const Color(0xFFFF9800), size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDark
                            ? 'Switch to Light Mode'
                            : 'Switch to Dark Mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                        Text(
                          isDark
                            ? 'Currently using dark theme'
                            : 'Currently using light theme',
                          style: TextStyle(
                            fontSize: 11,
                            color: subTextColor)),
                      ],
                    )),
                    // Toggle switch
                    Switch(
                      value: isDark,
                      onChanged: (_) =>
                        WaterStationApp.of(context)?.toggleTheme(),
                      activeColor: const Color(0xFF0077B6),
                      activeTrackColor:
                        const Color(0xFF0077B6).withOpacity(0.3),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              // Station Info section
              _SectionLabel('Station Info', subTextColor),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10),
                  ],
                ),
                child: Column(children: [
                  _InfoRow('Water Level',
                    '${AppState.waterLevel.toStringAsFixed(0)}%',
                    Icons.water_drop_outlined,
                    const Color(0xFF0077B6),
                    textColor, subTextColor),
                  const SizedBox(height: 12),
                  _InfoRow('TDS Reading',
                    '${AppState.tds.toStringAsFixed(0)} ppm',
                    Icons.science_outlined,
                    const Color(0xFF00B894),
                    textColor, subTextColor),
                  const SizedBox(height: 12),
                  _InfoRow('Last Refill',
                    AppState.lastRefill,
                    Icons.history,
                    const Color(0xFFFF9800),
                    textColor, subTextColor),
                  const SizedBox(height: 12),
                  _InfoRow('Firebase',
                    'Connected',
                    Icons.cloud_done_outlined,
                    const Color(0xFF00B894),
                    textColor, subTextColor),
                ]),
              ),
              const SizedBox(height: 20),

              // Danger zone
              _SectionLabel('Danger Zone', subTextColor),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE53935).withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10),
                  ],
                ),
                child: _MenuItem(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  color: const Color(0xFFE53935),
                  textColor: const Color(0xFFE53935),
                  subColor: const Color(0xFFE53935).withOpacity(0.6),
                  onTap: _logout,
                  showArrow: false,
                ),
              ),
              const SizedBox(height: 24),

              // Footer
              Center(
                child: Column(children: [
                  Text('AquaMonitor v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400)),
                  const SizedBox(height: 4),
                  Text('Smart Water Refilling Station Monitor',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400)),
                ]),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5));
  }
}

class _StatItem2 extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatItem2({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: Colors.white70, size: 18),
      const SizedBox(height: 4),
      Text(value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold)),
      Text(label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 11)),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color, textColor, subColor;
  const _InfoRow(this.label, this.value, this.icon,
    this.color, this.textColor, this.subColor);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(label,
        style: TextStyle(
          fontSize: 13,
          color: subColor))),
      Text(value,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: textColor)),
    ]);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color, textColor;
  final Color? subColor;
  final VoidCallback onTap;
  final bool showArrow;
  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.color,
    required this.textColor,
    this.subColor,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor)),
              if (subtitle != null)
                Text(subtitle!,
                  style: TextStyle(
                    fontSize: 11,
                    color: subColor ?? Colors.grey.shade400)),
            ],
          )),
          if (showArrow)
            Icon(Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400),
        ]),
      ),
    );
  }
}

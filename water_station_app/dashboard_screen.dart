import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'water_tips_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double get level => AppState.waterLevel;
  double get tds => AppState.tds;
  double get turb => AppState.turbidity;
  String get _lastRefill => AppState.lastRefill;

  DateTime _now = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _firstName {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'there';
    return name.trim().split(' ').first;
  }

  String get _greeting {
    final hour = _now.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _greetingEmoji {
    final hour = _now.hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    return '🌙';
  }

  String get _formattedTime {
    final h = _now.hour > 12
      ? _now.hour - 12
      : _now.hour == 0 ? 12 : _now.hour;
    final m = _now.minute.toString().padLeft(2, '0');
    final s = _now.second.toString().padLeft(2, '0');
    final period = _now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m:$s $period';
  }

  String get _formattedDate {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Sunday','Monday','Tuesday','Wednesday',
                  'Thursday','Friday','Saturday'];
    return '${days[_now.weekday % 7]}, ${months[_now.month - 1]} ${_now.day}, ${_now.year}';
  }

  String get _overallQuality {
    if (tds < 150 && turb < 1) return 'Excellent';
    if (tds < 200 && turb < 2) return 'Good';
    if (tds < 300 && turb < 4) return 'Fair';
    return 'Poor';
  }

  Color get _qualityColor {
    if (tds < 150 && turb < 1) return const Color(0xFF00B894);
    if (tds < 200 && turb < 2) return const Color(0xFF0096C7);
    if (tds < 300 && turb < 4) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  String get _quickTip {
    if (level < 30) return 'Tank is low! Schedule a refill soon.';
    if (tds > 300) return 'TDS is high. Consider replacing the filter.';
    if (turb > 3) return 'Water is cloudy. Check the filtration system.';
    if (level > 80) return 'Tank is full. Water quality looks great!';
    return 'Everything looks normal. Keep monitoring regularly.';
  }

  IconData get _quickTipIcon {
    if (level < 30) return Icons.water_drop_outlined;
    if (tds > 300) return Icons.warning_amber_outlined;
    if (turb > 3) return Icons.opacity_outlined;
    if (level > 80) return Icons.check_circle_outline;
    return Icons.tips_and_updates_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = WaterStationApp.of(context)?.isDarkMode ?? false;
    final bgColor = isDark
      ? const Color(0xFF060B14)
      : const Color(0xFFF0F4F8);
    final cardColor = isDark
      ? const Color(0xFF0D1421)
      : Colors.white;
    final textColor = isDark
      ? Colors.white
      : const Color(0xFF0D1B2A);
    final subTextColor = isDark
      ? Colors.grey.shade400
      : Colors.grey.shade500;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header with welcome message
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text('$_greeting, ',
                            style: TextStyle(
                              fontSize: 14,
                              color: subTextColor)),
                          Text('$_greetingEmoji',
                            style: const TextStyle(fontSize: 14)),
                        ]),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: _firstName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0096C7))),
                            TextSpan(
                              text: ' 👋',
                              style: TextStyle(
                                fontSize: 22,
                                color: textColor)),
                          ]),
                        ),
                        Text('AquaMonitor Station',
                          style: TextStyle(
                            fontSize: 12,
                            color: subTextColor)),
                      ],
                    ),
                  ),
                  Row(children: [
                    // Dark mode toggle
                    GestureDetector(
                      onTap: () =>
                        WaterStationApp.of(context)?.toggleTheme(),
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: isDark
                            ? const Color(0xFF1A2332)
                            : const Color(0xFFE1F0FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                              ? const Color(0xFF0096C7).withOpacity(0.2)
                              : const Color(0xFF0096C7).withOpacity(0.1)),
                        ),
                        child: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: const Color(0xFF0096C7),
                          size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Live badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B894).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00B894).withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        Container(
                          width: 7, height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00B894),
                            shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        const Text('Live',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00B894))),
                      ]),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 16),

              // Real-time clock card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 13),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                      ? const Color(0xFF0096C7).withOpacity(0.15)
                      : const Color(0xFF0096C7).withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        isDark ? 0.3 : 0.05),
                      blurRadius: 10),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0096C7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.access_time,
                          color: Color(0xFF0096C7), size: 16),
                      ),
                      const SizedBox(width: 10),
                      Text(_formattedTime,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0096C7))),
                    ]),
                    Flexible(
                      child: Text(_formattedDate,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          color: subTextColor)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Alert banner
              if (level < 30) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFE53935), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Low Water Level',
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                          Text('Refill needed soon',
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontSize: 11)),
                        ],
                      )),
                  ]),
                ),
                const SizedBox(height: 14),
              ],

              // Quick Tip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _qualityColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _qualityColor.withOpacity(0.2)),
                ),
                child: Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: _qualityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_quickTipIcon,
                      color: _qualityColor, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(_quickTip,
                      style: TextStyle(
                        fontSize: 13,
                        color: _qualityColor,
                        fontWeight: FontWeight.w500))),
                ]),
              ),
              const SizedBox(height: 16),

              // Section: Water Level
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Water Level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0096C7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Main Tank',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0096C7),
                        fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Water level card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF023E8A), Color(0xFF0096C7),
                             Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0096C7).withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Level',
                          style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            level > 60 ? '✓ Good'
                            : level > 30 ? '⚡ Medium' : '⚠ Low',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('${level.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        height: 1.1)),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: level / 100,
                        backgroundColor:
                          Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(
                          Colors.white),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(level * 0.5).toStringAsFixed(0)} L of 50 L',
                          style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                        Row(children: [
                          const Icon(Icons.history,
                            color: Colors.white60, size: 12),
                          const SizedBox(width: 4),
                          Text('Last refill: $_lastRefill',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Water Quality
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Water Quality',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _qualityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _qualityColor.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        Icon(Icons.verified,
                          color: _qualityColor, size: 12),
                        const SizedBox(width: 4),
                        Text(_overallQuality,
                          style: TextStyle(
                            color: _qualityColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    const SizedBox(width: 8),
                    // Water tips button
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => const WaterTipsScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0096C7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF0096C7)
                              .withOpacity(0.2)),
                        ),
                        child: const Row(children: [
                          Icon(Icons.lightbulb_outline,
                            color: Color(0xFF0096C7), size: 12),
                          SizedBox(width: 4),
                          Text('Tips',
                            style: TextStyle(
                              color: Color(0xFF0096C7),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 10),

              // TDS and Turbidity cards
              Row(children: [
                Expanded(child: _QualityCard(
                  label: 'TDS Level',
                  value: tds.toStringAsFixed(0),
                  unit: 'ppm',
                  status: tds < 150 ? 'Excellent'
                    : tds < 200 ? 'Good' : 'Poor',
                  icon: Icons.science_outlined,
                  color: tds < 150 ? const Color(0xFF00B894)
                    : tds < 200 ? const Color(0xFF0096C7)
                    : const Color(0xFFFF9800),
                  progress: tds / 300,
                  cardColor: cardColor,
                  isDark: isDark,
                )),
                const SizedBox(width: 12),
                Expanded(child: _QualityCard(
                  label: 'Turbidity',
                  value: turb.toStringAsFixed(1),
                  unit: 'NTU',
                  status: turb < 1 ? 'Clear'
                    : turb < 2 ? 'Good' : 'Cloudy',
                  icon: Icons.opacity_outlined,
                  color: turb < 1 ? const Color(0xFF00B894)
                    : turb < 2 ? const Color(0xFF0096C7)
                    : const Color(0xFFFF9800),
                  progress: turb / 5,
                  cardColor: cardColor,
                  isDark: isDark,
                )),
              ]),
              const SizedBox(height: 14),

              // Quality Analysis Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.04)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        isDark ? 0.3 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quality Analysis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0096C7))),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _qualityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _qualityColor.withOpacity(0.2)),
                          ),
                          child: Text(
                            tds < 300 && turb < 4
                              ? '✓ Safe to drink'
                              : '✗ Not recommended',
                            style: TextStyle(
                              fontSize: 11,
                              color: _qualityColor,
                              fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _QualityRow(
                      'TDS Level',
                      '${tds.toStringAsFixed(0)} ppm',
                      tds < 150 ? 'Excellent'
                      : tds < 200 ? 'Good' : 'Poor',
                      tds / 300,
                      tds < 150 ? const Color(0xFF00B894)
                      : tds < 200 ? const Color(0xFF0096C7)
                      : const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 14),
                    _QualityRow(
                      'Turbidity',
                      '${turb.toStringAsFixed(1)} NTU',
                      turb < 1 ? 'Crystal Clear'
                      : turb < 2 ? 'Clear' : 'Cloudy',
                      turb / 5,
                      turb < 1 ? const Color(0xFF00B894)
                      : turb < 2 ? const Color(0xFF0096C7)
                      : const Color(0xFFFF9800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Last updated
              Center(
                child: Text('Last updated: just now',
                  style: TextStyle(
                    fontSize: 12,
                    color: subTextColor)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _QualityCard extends StatelessWidget {
  final String label, value, unit, status;
  final IconData icon;
  final Color color, cardColor;
  final double progress;
  final bool isDark;
  const _QualityCard({
    required this.label, required this.value,
    required this.unit, required this.status,
    required this.icon, required this.color,
    required this.progress, required this.cardColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
            ? Colors.white.withOpacity(0.05)
            : color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(text: TextSpan(children: [
            TextSpan(text: value,
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
            TextSpan(text: ' $unit',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12)),
          ])),
          const SizedBox(height: 4),
          Text(label,
            style: TextStyle(
              color: Colors.grey.shade500, fontSize: 11)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityRow extends StatelessWidget {
  final String label, value, status;
  final double progress;
  final Color color;
  const _QualityRow(
    this.label, this.value, this.status, this.progress, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
              style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 13)),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(status,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 6),
        Text(value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500)),
      ],
    );
  }
}
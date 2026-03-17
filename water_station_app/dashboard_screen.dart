import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
double get level => AppState.waterLevel;
double get tds => AppState.tds;
double get turb => AppState.turbidity;
  DateTime _now = DateTime.now();
  late Timer _timer;
  final String _lastRefill = 'Mar 12, 08:30 AM';

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

  String get _greeting {
    final hour = _now.hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  String get _formattedTime {
    final h = _now.hour > 12 ? _now.hour - 12 : _now.hour == 0 ? 12 : _now.hour;
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
    if (tds < 200 && turb < 2) return const Color(0xFF0077B6);
    if (tds < 300 && turb < 4) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  String get _quickTip {
    if (level < 30) return '💧 Tank is low! Schedule a refill soon.';
    if (tds > 300) return '⚠️ TDS is high. Consider replacing the filter.';
    if (turb > 3) return '🌊 Water is cloudy. Check the filtration system.';
    if (level > 80) return '✅ Tank is full. Water quality looks great!';
    return '👍 Everything looks normal. Keep monitoring regularly.';
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

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header with dark mode toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_greeting,
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor)),
                      Text('Station Monitor',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0077B6))),
                    ],
                  ),
                  Row(children: [
                    // Dark mode toggle
                    GestureDetector(
                      onTap: () => WaterStationApp.of(context)?.toggleTheme(),
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: isDark
                            ? const Color(0xFF1E2A3A)
                            : const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: const Color(0xFF0077B6),
                          size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Live badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(children: [
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00B894),
                            shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
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
                  horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(Icons.access_time,
                        color: const Color(0xFF0077B6), size: 18),
                      const SizedBox(width: 8),
                      Text(_formattedTime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0077B6))),
                    ]),
                    Text(_formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: subTextColor)),
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
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFE53935), size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Low Water Level — Refill Needed',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w600,
                          fontSize: 13))),
                  ]),
                ),
                const SizedBox(height: 14),
              ],

              // Quick Tip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _qualityColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _qualityColor.withOpacity(0.2)),
                ),
                child: Text(_quickTip,
                  style: TextStyle(
                    fontSize: 13,
                    color: _qualityColor,
                    fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 16),

              // Section: Water Level
              Text('Water Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0077B6).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8)),
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
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
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
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        height: 1.1)),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: level / 100,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
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
                            color: Colors.white70, size: 13),
                          const SizedBox(width: 4),
                          Text('Last refill: $_lastRefill',
                            style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: _qualityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Icon(Icons.verified,
                        color: _qualityColor, size: 14),
                      const SizedBox(width: 5),
                      Text(_overallQuality,
                        style: TextStyle(
                          color: _qualityColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                    ]),
                  ),
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
                    : tds < 200 ? const Color(0xFF0077B6)
                    : const Color(0xFFFF9800),
                  progress: tds / 300,
                  cardColor: cardColor,
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
                    : turb < 2 ? const Color(0xFF0077B6)
                    : const Color(0xFFFF9800),
                  progress: turb / 5,
                  cardColor: cardColor,
                )),
              ]),
              const SizedBox(height: 14),

              // Quality Analysis Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                        Text('Quality Analysis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: const Color(0xFF0077B6))),
                        Text('Safe to drink',
                          style: TextStyle(
                            fontSize: 12,
                            color: _qualityColor,
                            fontWeight: FontWeight.w500)),
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
                      : tds < 200 ? const Color(0xFF0077B6)
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
                      : turb < 2 ? const Color(0xFF0077B6)
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
  const _QualityCard({
    required this.label, required this.value,
    required this.unit, required this.status,
    required this.icon, required this.color,
    required this.progress, required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(icon, color: color, size: 20),
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
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
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
            backgroundColor: Colors.grey.shade100,
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
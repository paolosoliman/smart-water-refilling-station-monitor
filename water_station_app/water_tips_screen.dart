import 'package:flutter/material.dart';
import '../main.dart';

class WaterTipsScreen extends StatelessWidget {
  const WaterTipsScreen({super.key});

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
        child: Column(
          children: [

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                      size: 16, color: Color(0xFF0096C7)),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Water Quality Tips',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0096C7))),
                    Text('Keep your water safe and clean',
                      style: TextStyle(
                        fontSize: 12,
                        color: subTextColor)),
                  ],
                ),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    // Hero card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                            color: const Color(0xFF0096C7).withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Row(children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.water_drop,
                            size: 32, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Clean Water Guide',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(
                              'Learn how to maintain safe and high quality drinking water for your station.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12)),
                          ],
                        )),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // TDS Tips
                    _TipSection(
                      title: 'TDS (Total Dissolved Solids)',
                      icon: Icons.science_outlined,
                      color: const Color(0xFF0096C7),
                      cardColor: cardColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      tips: [
                        _TipItem(
                          range: '0 - 50 ppm',
                          label: 'Too Pure',
                          desc: 'May lack essential minerals. Not ideal for drinking.',
                          color: const Color(0xFF0096C7),
                          icon: Icons.info_outline,
                        ),
                        _TipItem(
                          range: '50 - 150 ppm',
                          label: 'Excellent',
                          desc: 'Ideal drinking water. Best quality for consumption.',
                          color: const Color(0xFF00B894),
                          icon: Icons.check_circle_outline,
                        ),
                        _TipItem(
                          range: '150 - 250 ppm',
                          label: 'Good',
                          desc: 'Good quality water. Safe for daily drinking.',
                          color: const Color(0xFF00B894),
                          icon: Icons.check_circle_outline,
                        ),
                        _TipItem(
                          range: '250 - 350 ppm',
                          label: 'Fair',
                          desc: 'Acceptable but consider filtering. Check your filter.',
                          color: const Color(0xFFFF9800),
                          icon: Icons.warning_amber_outlined,
                        ),
                        _TipItem(
                          range: '350+ ppm',
                          label: 'Poor',
                          desc: 'Not recommended for drinking. Replace filter immediately.',
                          color: const Color(0xFFE53935),
                          icon: Icons.error_outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Turbidity Tips
                    _TipSection(
                      title: 'Turbidity',
                      icon: Icons.opacity_outlined,
                      color: const Color(0xFF00B894),
                      cardColor: cardColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      tips: [
                        _TipItem(
                          range: '0 - 1 NTU',
                          label: 'Crystal Clear',
                          desc: 'Excellent clarity. Water is perfectly clear.',
                          color: const Color(0xFF00B894),
                          icon: Icons.check_circle_outline,
                        ),
                        _TipItem(
                          range: '1 - 2 NTU',
                          label: 'Clear',
                          desc: 'Good clarity. Safe for drinking.',
                          color: const Color(0xFF00B894),
                          icon: Icons.check_circle_outline,
                        ),
                        _TipItem(
                          range: '2 - 4 NTU',
                          label: 'Slightly Cloudy',
                          desc: 'Slightly cloudy. Monitor and check filtration.',
                          color: const Color(0xFFFF9800),
                          icon: Icons.warning_amber_outlined,
                        ),
                        _TipItem(
                          range: '4+ NTU',
                          label: 'Cloudy',
                          desc: 'Not recommended. Clean or replace filter immediately.',
                          color: const Color(0xFFE53935),
                          icon: Icons.error_outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Water Level Tips
                    _TipSection(
                      title: 'Water Level',
                      icon: Icons.water_drop_outlined,
                      color: const Color(0xFF0096C7),
                      cardColor: cardColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      tips: [
                        _TipItem(
                          range: '70% - 100%',
                          label: 'Full',
                          desc: 'Tank is full. No action needed.',
                          color: const Color(0xFF00B894),
                          icon: Icons.check_circle_outline,
                        ),
                        _TipItem(
                          range: '40% - 70%',
                          label: 'Medium',
                          desc: 'Good level. Schedule a refill soon.',
                          color: const Color(0xFF0096C7),
                          icon: Icons.info_outline,
                        ),
                        _TipItem(
                          range: '20% - 40%',
                          label: 'Low',
                          desc: 'Water is getting low. Refill recommended.',
                          color: const Color(0xFFFF9800),
                          icon: Icons.warning_amber_outlined,
                        ),
                        _TipItem(
                          range: '0% - 20%',
                          label: 'Critical',
                          desc: 'Critically low! Refill immediately to avoid shortage.',
                          color: const Color(0xFFE53935),
                          icon: Icons.error_outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Maintenance Tips
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.3 : 0.05),
                            blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800)
                                  .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.build_outlined,
                                color: Color(0xFFFF9800), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Text('Maintenance Tips',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF9800))),
                          ]),
                          const SizedBox(height: 16),
                          _MaintenanceTip('🔄',
                            'Clean the tank regularly',
                            'Drain and clean your tank every 3-6 months to prevent bacteria buildup.',
                            subTextColor),
                          _MaintenanceTip('🔬',
                            'Check sensors monthly',
                            'Clean sensor probes to ensure accurate readings of TDS and turbidity.',
                            subTextColor),
                          _MaintenanceTip('💧',
                            'Replace filters on time',
                            'Replace water filters every 6-12 months or when TDS exceeds 300 ppm.',
                            subTextColor),
                          _MaintenanceTip('📊',
                            'Monitor regularly',
                            'Check water quality daily using the AquaMonitor app for early detection of issues.',
                            subTextColor),
                          _MaintenanceTip('🚿',
                            'Keep pipes clean',
                            'Flush pipes regularly to prevent sediment and bacterial growth.',
                            subTextColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color, cardColor, textColor, subTextColor;
  final List<_TipItem> tips;
  const _TipSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Text(title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color)),
          ]),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: tip.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(tip.icon,
                    color: tip.color, size: 14),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: tip.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(tip.range,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tip.color)),
                      ),
                      const SizedBox(width: 6),
                      Text(tip.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: tip.color)),
                    ]),
                    const SizedBox(height: 3),
                    Text(tip.desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: subTextColor,
                        height: 1.4)),
                  ],
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TipItem {
  final String range, label, desc;
  final Color color;
  final IconData icon;
  const _TipItem({
    required this.range,
    required this.label,
    required this.desc,
    required this.color,
    required this.icon,
  });
}

class _MaintenanceTip extends StatelessWidget {
  final String emoji, title, desc;
  final Color subTextColor;
  const _MaintenanceTip(
    this.emoji, this.title, this.desc, this.subTextColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(desc,
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                  height: 1.4)),
            ],
          )),
        ],
      ),
    );
  }
}

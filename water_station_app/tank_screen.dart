import 'package:flutter/material.dart';
import '../main.dart';

class TankScreen extends StatefulWidget {
  const TankScreen({super.key});
  @override
  State<TankScreen> createState() => _TankScreenState();
}

class _TankScreenState extends State<TankScreen> {
  bool _draining = false;
  bool _refilling = false;
double get level => AppState.waterLevel;
set level(double v) => AppState.waterLevel = v;
String get _lastRefill => AppState.lastRefill;
set _lastRefill(String v) => AppState.lastRefill = v;

  Future<void> _confirmDrain() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.warning_amber_rounded,
            color: Color(0xFFE53935)),
          SizedBox(width: 8),
          Text('Drain the Tank?'),
        ]),
        content: const Text(
          'This will send a drain command to the ESP32 and empty the tank. Use only for maintenance.'),
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
            child: const Text('Drain Now')),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _draining = true);
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() {
          _draining = false;
          level = 0;
        });
      });
    }
  }

  Future<void> _confirmRefill() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.water_drop,
            color: Color(0xFF0077B6)),
          SizedBox(width: 8),
          Text('Refill the Tank?'),
        ]),
        content: const Text(
          'This will send a refill command to the ESP32 to start filling the tank.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0077B6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Refill Now')),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _refilling = true);
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() {
          _refilling = false;
          level = 100;
          final now = DateTime.now();
          const months = ['Jan','Feb','Mar','Apr','May',
            'Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
          final h = now.hour > 12
            ? now.hour - 12
            : now.hour == 0 ? 12 : now.hour;
          final m = now.minute.toString().padLeft(2, '0');
          final period = now.hour >= 12 ? 'PM' : 'AM';
          _lastRefill =
            '${months[now.month - 1]} ${now.day}, $h:$m $period';
        });
      });
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

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Text('Tank Control',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0077B6))),
              Text('Monitor and control your water tank',
                style: TextStyle(
                  fontSize: 13,
                  color: subTextColor)),
              const SizedBox(height: 24),

              // Tank visual card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tank visualization
                    Column(children: [
                      Container(
                        width: 90, height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF0077B6), width: 2),
                          borderRadius: BorderRadius.circular(14),
                          color: isDark
                            ? const Color(0xFF0A1628)
                            : const Color(0xFFF0F8FF),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            FractionallySizedBox(
                              heightFactor:
                                (level / 100).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: level > 60
                                      ? [const Color(0xFF0077B6),
                                         const Color(0xFF00B4D8)]
                                      : level > 30
                                        ? [const Color(0xFFFF9800),
                                           const Color(0xFFFFB74D)]
                                        : [const Color(0xFFE53935),
                                           const Color(0xFFEF5350)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius:
                                    const BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                ),
                              ),
                            ),
                            Center(child: Text(
                              '${level.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: level > 20
                                  ? Colors.white
                                  : const Color(0xFF0077B6)))),
                          ]),
                      ),
                      const SizedBox(height: 8),
                      Text('Main Tank',
                        style: TextStyle(
                          fontSize: 12,
                          color: subTextColor,
                          fontWeight: FontWeight.w500)),
                    ]),

                    // Stats column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatItem('Volume',
                          '${(level * 0.5).toStringAsFixed(0)} L',
                          textColor, subTextColor),
                        _StatItem('Capacity', '50 L',
                          textColor, subTextColor),
                        _StatItem('Status',
                          level > 60 ? 'Full'
                          : level > 30 ? 'Medium' : 'Low',
                          textColor, subTextColor),
                        _StatItem('Last Refill', _lastRefill,
                          textColor, subTextColor),
                        _StatItem('ESP32', 'Connected',
                          textColor, subTextColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Level progress bar card
              Container(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fill Level',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: textColor)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: level > 60
                              ? const Color(0xFFE8F5E9)
                              : level > 30
                                ? const Color(0xFFFFF8E1)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${level.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: level > 60
                                ? const Color(0xFF00B894)
                                : level > 30
                                  ? const Color(0xFFFF9800)
                                  : const Color(0xFFE53935),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: level / 100,
                        backgroundColor: const Color(0xFFE3F2FD),
                        valueColor: AlwaysStoppedAnimation(
                          level > 60
                            ? const Color(0xFF00B894)
                            : level > 30
                              ? const Color(0xFFFF9800)
                              : const Color(0xFFE53935)),
                        minHeight: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0%',
                          style: TextStyle(
                            fontSize: 11,
                            color: subTextColor)),
                        Text('50%',
                          style: TextStyle(
                            fontSize: 11,
                            color: subTextColor)),
                        Text('100%',
                          style: TextStyle(
                            fontSize: 11,
                            color: subTextColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Refill + Drain buttons card
              Container(
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
                    Text('Tank Controls',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor)),
                    const SizedBox(height: 10),

                    // Warning info box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFE082)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.info_outline,
                          color: Color(0xFFFF9800), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Use these controls carefully. Commands are sent directly to the ESP32.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800))),
                      ]),
                    ),
                    const SizedBox(height: 16),

                    // Refill progress
                    if (_refilling) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          color: Color(0xFF0077B6),
                          backgroundColor: Color(0xFFE3F2FD),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Refilling in progress...',
                        style: TextStyle(
                          color: Color(0xFF0077B6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                    ],

                    // Drain progress
                    if (_draining) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          color: Color(0xFFE53935),
                          backgroundColor: Color(0xFFFFEBEE),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Draining in progress...',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                    ],

                    // Two buttons side by side
                    Row(children: [
                      // Refill button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: _refilling || _draining
                                ? Colors.grey.shade300
                                : const Color(0xFF0077B6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _refilling || _draining
                              ? null
                              : _confirmRefill,
                            icon: const Icon(Icons.water_drop,
                              size: 18),
                            label: Text(
                              _refilling ? 'Refilling...' : 'Refill Tank',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Drain button
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: _draining || _refilling
                                ? Colors.grey.shade300
                                : const Color(0xFFE53935),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _draining || _refilling
                              ? null
                              : _confirmDrain,
                            icon: const Icon(
                              Icons.water_drop_outlined,
                              size: 18),
                            label: Text(
                              _draining ? 'Draining...' : 'Drain Tank',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final Color textColor, subTextColor;
  const _StatItem(this.label, this.value,
    this.textColor, this.subTextColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: TextStyle(
              fontSize: 11,
              color: subTextColor)),
          Text(value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0077B6))),
        ],
      ),
    );
  }
}
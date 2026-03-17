import 'package:flutter/material.dart';
import '../main.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _history = [
    {'time': 'Mar 12, 09:00', 'level': 65, 'tds': 143, 'turb': 1.2, 'status': 'Normal'},
    {'time': 'Mar 12, 07:00', 'level': 58, 'tds': 155, 'turb': 1.4, 'status': 'Normal'},
    {'time': 'Mar 12, 05:00', 'level': 50, 'tds': 162, 'turb': 1.1, 'status': 'Normal'},
    {'time': 'Mar 11, 23:00', 'level': 45, 'tds': 178, 'turb': 1.8, 'status': 'Normal'},
    {'time': 'Mar 11, 21:00', 'level': 28, 'tds': 210, 'turb': 2.5, 'status': 'Alert'},
    {'time': 'Mar 11, 19:00', 'level': 80, 'tds': 140, 'turb': 0.8, 'status': 'Normal'},
    {'time': 'Mar 11, 17:00', 'level': 75, 'tds': 135, 'turb': 0.9, 'status': 'Normal'},
    {'time': 'Mar 11, 15:00', 'level': 60, 'tds': 190, 'turb': 1.5, 'status': 'Normal'},
    {'time': 'Mar 11, 13:00', 'level': 25, 'tds': 320, 'turb': 3.2, 'status': 'Alert'},
    {'time': 'Mar 11, 11:00', 'level': 90, 'tds': 125, 'turb': 0.7, 'status': 'Normal'},
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_filter == 'Normal') {
      return _history.where((r) => r['status'] == 'Normal').toList();
    }
    if (_filter == 'Alert') {
      return _history.where((r) => r['status'] == 'Alert').toList();
    }
    return _history;
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

    final normal = _history.where((r) => r['status'] == 'Normal').length;
    final alerts = _history.where((r) => r['status'] == 'Alert').length;

    // Average TDS
    final avgTds = _history.isEmpty
      ? 0.0
      : _history.map((r) => r['tds'] as int)
          .reduce((a, b) => a + b) / _history.length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data History',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0077B6))),
                      Text('Last ${_history.length} readings',
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor)),
                    ],
                  ),
                  // Refresh button
                  GestureDetector(
                    onTap: () => setState(() {}),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.refresh,
                        color: Color(0xFF0077B6), size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary cards
              Row(children: [
                Expanded(child: _SummaryCard(
                  label: 'Normal',
                  value: '$normal',
                  color: const Color(0xFF00B894),
                  icon: Icons.check_circle_outline,
                  cardColor: cardColor,
                )),
                const SizedBox(width: 10),
                Expanded(child: _SummaryCard(
                  label: 'Alerts',
                  value: '$alerts',
                  color: const Color(0xFFE53935),
                  icon: Icons.warning_amber_outlined,
                  cardColor: cardColor,
                )),
                const SizedBox(width: 10),
                Expanded(child: _SummaryCard(
                  label: 'Avg TDS',
                  value: avgTds.toStringAsFixed(0),
                  color: const Color(0xFF0077B6),
                  icon: Icons.science_outlined,
                  cardColor: cardColor,
                )),
              ]),
              const SizedBox(height: 16),

              // Filter tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final f in ['All', 'Normal', 'Alert'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _filter == f
                              ? const Color(0xFF0077B6)
                              : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _filter == f
                                ? const Color(0xFF0077B6)
                                : Colors.grey.shade200),
                          ),
                          child: Text(f,
                            style: TextStyle(
                              color: _filter == f
                                ? Colors.white
                                : subTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                ]),
              ),
              const SizedBox(height: 14),

              // Table header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(children: [
                  Expanded(flex: 3, child: Text('Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12))),
                  Expanded(child: Text('Level',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12))),
                  Expanded(child: Text('TDS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12))),
                  Expanded(child: Text('Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12))),
                ]),
              ),
              const SizedBox(height: 10),

              // Table rows
              Expanded(
                child: _filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart,
                            size: 60,
                            color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No records found',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredHistory.length,
                      separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final r = _filteredHistory[i];
                        final isNormal = r['status'] == 'Normal';

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isNormal
                                ? Colors.transparent
                                : const Color(0xFFFFCDD2),
                              width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(children: [
                            Expanded(flex: 3, child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r['time'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: subTextColor)),
                                Text('Turb: ${r['turb']} NTU',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade400)),
                              ],
                            )),
                            Expanded(child: Text('${r['level']}%',
                              style: TextStyle(
                                color: r['level'] > 50
                                  ? const Color(0xFF00B894)
                                  : const Color(0xFFFF9800),
                                fontWeight: FontWeight.bold,
                                fontSize: 12))),
                            Expanded(child: Text('${r['tds']}',
                              style: TextStyle(
                                color: r['tds'] < 200
                                  ? const Color(0xFF0077B6)
                                  : const Color(0xFFFF9800),
                                fontWeight: FontWeight.bold,
                                fontSize: 12))),
                            Expanded(child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: isNormal
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(r['status'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isNormal
                                    ? const Color(0xFF00B894)
                                    : const Color(0xFFE53935),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                            )),
                          ]),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value;
  final Color color, cardColor;
  final IconData icon;
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3)),
        ],
      ),
      child: Column(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 8),
        Text(value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold)),
        Text(label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500)),
      ]),
    );
  }
}

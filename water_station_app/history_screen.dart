import 'package:flutter/material.dart';
import '../main.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';

  List<Map<String, dynamic>> get _history => AppState.history;

  List<Map<String, dynamic>> get _filteredHistory {
    List<Map<String, dynamic>> list = _history;
    final now = DateTime.now();

    if (_filter == 'This Week') {
      final weekAgo = now.subtract(const Duration(days: 7));
      list = list.where((r) {
        final ts = r['timestamp'] as DateTime?;
        return ts != null && ts.isAfter(weekAgo);
      }).toList();
    } else if (_filter == 'This Month') {
      list = list.where((r) {
        final ts = r['timestamp'] as DateTime?;
        return ts != null &&
          ts.month == now.month &&
          ts.year == now.year;
      }).toList();
    } else if (_filter == 'Refill') {
      list = list.where((r) => r['action'] == 'Refill').toList();
    } else if (_filter == 'Drain') {
      list = list.where((r) => r['action'] == 'Drain').toList();
    }

    return list;
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

    final refillCount = _history
      .where((r) => r['action'] == 'Refill').length;
    final drainCount = _history
      .where((r) => r['action'] == 'Drain').length;
    final alertCount = _history
      .where((r) => r['status'] == 'Alert').length;

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
                      Text(
                        _history.isEmpty
                          ? 'No records yet'
                          : '${_history.length} total records',
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor)),
                    ],
                  ),
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

              if (_history.isNotEmpty) ...[
                // Summary cards
                Row(children: [
                  Expanded(child: _SummaryCard(
                    label: 'Refills',
                    value: '$refillCount',
                    color: const Color(0xFF0077B6),
                    icon: Icons.water_drop_outlined,
                    cardColor: cardColor,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _SummaryCard(
                    label: 'Drains',
                    value: '$drainCount',
                    color: const Color(0xFFE53935),
                    icon: Icons.water_drop,
                    cardColor: cardColor,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _SummaryCard(
                    label: 'Alerts',
                    value: '$alertCount',
                    color: const Color(0xFFFF9800),
                    icon: Icons.warning_amber_outlined,
                    cardColor: cardColor,
                  )),
                ]),
                const SizedBox(height: 16),

                // Filter tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (final f in [
                      'All', 'This Week', 'This Month',
                      'Refill', 'Drain'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
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
                                fontSize: 12,
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
                    Expanded(child: Text('Action',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12))),
                    Expanded(child: Text('Level',
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
              ],

              // Table rows
              Expanded(
                child: _filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.history,
                              size: 40,
                              color: Color(0xFF0077B6)),
                          ),
                          const SizedBox(height: 16),
                          Text('No history yet',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            'History will appear here when\nyou refill or drain the tank.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 13)),
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
                        final isRefill = r['action'] == 'Refill';
                        final actionColor = isRefill
                          ? const Color(0xFF0077B6)
                          : const Color(0xFFE53935);

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
                                    fontWeight: FontWeight.w500,
                                    color: subTextColor)),
                                if (r['detail'] != null)
                                  Text(r['detail'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400)),
                              ],
                            )),
                            Expanded(child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: actionColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(r['action'] ?? '-',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: actionColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                            )),
                            const SizedBox(width: 8),
                            Expanded(child: Text(
                              '${(r['level'] as double).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: r['level'] > 50
                                  ? const Color(0xFF00B894)
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

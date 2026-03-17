import 'package:flutter/material.dart';
import '../main.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _alerts = [
    {
      'type': 'warning',
      'msg': 'Water level dropped below 30%',
      'detail': 'Current level is at 28%. Please refill the tank soon.',
      'time': '2:14 PM',
      'read': false,
    },
    {
      'type': 'alert',
      'msg': 'TDS level slightly elevated',
      'detail': 'TDS reading is 210 ppm. Normal range is below 200 ppm.',
      'time': 'Yesterday, 10:42 AM',
      'read': false,
    },
    {
      'type': 'success',
      'msg': 'Tank refilled successfully',
      'detail': 'Tank is now at 80% capacity.',
      'time': 'Yesterday, 9:01 AM',
      'read': true,
    },
    {
      'type': 'info',
      'msg': 'System connected to Firebase',
      'detail': 'ESP32 is online and sending data.',
      'time': '2 days ago',
      'read': true,
    },
  ];

  int get _unreadCount => _alerts.where((a) => !a['read']).length;

  List<Map<String, dynamic>> get _filteredAlerts {
    if (_filter == 'Unread') return _alerts.where((a) => !a['read']).toList();
    if (_filter == 'Alerts') return _alerts.where((a) => a['type'] == 'alert' || a['type'] == 'warning').toList();
    return _alerts;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = WaterStationApp.of(context)?.isDarkMode ?? false;
    final bgColor = isDark ? const Color(0xFF0A0E1A) : const Color(0xFFF8FAFE);
    final cardColor = isDark ? const Color(0xFF111827) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;

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
                      Text('Notifications',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0077B6))),
                      Text(
                        '$_unreadCount unread alert${_unreadCount != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor)),
                    ],
                  ),
                  if (_unreadCount > 0)
                    TextButton(
                      onPressed: () => setState(() {
                        for (var a in _alerts) a['read'] = true;
                      }),
                      child: const Text('Mark all read',
                        style: TextStyle(
                          color: Color(0xFF0077B6),
                          fontSize: 13)),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary stats row
              Row(children: [
                _StatBadge(
                  label: 'Total',
                  count: _alerts.length,
                  color: const Color(0xFF0077B6),
                  cardColor: cardColor,
                ),
                const SizedBox(width: 8),
                _StatBadge(
                  label: 'Unread',
                  count: _unreadCount,
                  color: const Color(0xFFE53935),
                  cardColor: cardColor,
                ),
                const SizedBox(width: 8),
                _StatBadge(
                  label: 'Warnings',
                  count: _alerts.where((a) =>
                    a['type'] == 'alert' || a['type'] == 'warning').length,
                  color: const Color(0xFFFF9800),
                  cardColor: cardColor,
                ),
              ]),
              const SizedBox(height: 16),

              // Filter tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final f in ['All', 'Unread', 'Alerts'])
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
              const SizedBox(height: 16),

              // Alert list
              Expanded(
                child: _filteredAlerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none,
                            size: 60, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No alerts here',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredAlerts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final a = _filteredAlerts[i];
                        final isAlert = a['type'] == 'alert';
                        final isWarning = a['type'] == 'warning';
                        final isSuccess = a['type'] == 'success';

                        final color = isAlert
                          ? const Color(0xFFE53935)
                          : isWarning
                            ? const Color(0xFFFF9800)
                            : isSuccess
                              ? const Color(0xFF00B894)
                              : const Color(0xFF0077B6);

                        final bgColor2 = isAlert
                          ? const Color(0xFFFFEBEE)
                          : isWarning
                            ? const Color(0xFFFFF8E1)
                            : isSuccess
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFE3F2FD);

                        final icon = isAlert
                          ? Icons.error_outline
                          : isWarning
                            ? Icons.warning_amber_outlined
                            : isSuccess
                              ? Icons.check_circle_outline
                              : Icons.info_outline;

                        return GestureDetector(
                          onTap: () => setState(() => a['read'] = true),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: a['read']
                                  ? Colors.transparent
                                  : color.withOpacity(0.25),
                                width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3)),
                              ],
                            ),
                            child: Row(children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: bgColor2,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a['msg'],
                                      style: TextStyle(
                                        fontWeight: a['read']
                                          ? FontWeight.w500
                                          : FontWeight.bold,
                                        fontSize: 14,
                                        color: textColor)),
                                    const SizedBox(height: 3),
                                    Text(a['detail'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subTextColor)),
                                    const SizedBox(height: 5),
                                    Row(children: [
                                      Icon(Icons.access_time,
                                        size: 11,
                                        color: Colors.grey.shade400),
                                      const SizedBox(width: 4),
                                      Text(a['time'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade400)),
                                    ]),
                                  ],
                                ),
                              ),
                              if (!a['read'])
                                Container(
                                  width: 10, height: 10,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle),
                                ),
                            ]),
                          ),
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

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color cardColor;
  const _StatBadge({
    required this.label,
    required this.count,
    required this.color,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6),
        ],
      ),
      child: Row(children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$count $label',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
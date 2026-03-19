import 'package:flutter/material.dart';
import '../main.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button
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
                    size: 16, color: Color(0xFF0077B6)),
                ),
              ),
              const SizedBox(height: 32),

              // App logo and name
              Center(
                child: Column(children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0077B6).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.water_drop,
                      size: 54, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text('AquaMonitor',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0077B6))),
                  const SizedBox(height: 6),
                  Text('Version 1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: subTextColor)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Smart Water Refilling Station Monitor',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0077B6),
                        fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
              const SizedBox(height: 32),

              // About section
              _SectionCard(
                cardColor: cardColor,
                title: 'About the App',
                titleColor: const Color(0xFF0077B6),
                children: [
                  _InfoText(
                    text: 'AquaMonitor is a smart mobile application designed to monitor water quality and refilling status in a water refilling station in real time.',
                    color: subTextColor),
                  const SizedBox(height: 10),
                  _InfoText(
                    text: 'It uses IoT sensors connected to an ESP32 microcontroller to collect water level and quality data, which is then transmitted to Firebase and displayed on this app.',
                    color: subTextColor),
                ],
              ),
              const SizedBox(height: 16),

              // Features section
              _SectionCard(
                cardColor: cardColor,
                title: 'Features',
                titleColor: const Color(0xFF0077B6),
                children: [
                  _FeatureItem(
                    icon: Icons.water_drop_outlined,
                    label: 'Real-time water level monitoring',
                    color: const Color(0xFF0077B6)),
                  _FeatureItem(
                    icon: Icons.science_outlined,
                    label: 'TDS and Turbidity water quality monitoring',
                    color: const Color(0xFF00B894)),
                  _FeatureItem(
                    icon: Icons.notifications_outlined,
                    label: 'Alerts when water is low or quality is abnormal',
                    color: const Color(0xFFFF9800)),
                  _FeatureItem(
                    icon: Icons.history,
                    label: 'Historical data records',
                    color: const Color(0xFFE53935)),
                  _FeatureItem(
                    icon: Icons.water_drop,
                    label: 'Remote drain and refill tank control',
                    color: const Color(0xFF0077B6)),
                  _FeatureItem(
                    icon: Icons.dark_mode,
                    label: 'Dark mode support',
                    color: const Color(0xFF4A148C)),
                ],
              ),
              const SizedBox(height: 16),

              // IoT components
              _SectionCard(
                cardColor: cardColor,
                title: 'IoT Components Used',
                titleColor: const Color(0xFF0077B6),
                children: [
                  _ComponentItem(
                    name: 'ESP32',
                    desc: 'Main microcontroller with WiFi',
                    color: const Color(0xFF0077B6),
                    textColor: textColor,
                    subColor: subTextColor),
                  _ComponentItem(
                    name: 'HC-SR04',
                    desc: 'Ultrasonic sensor for water level',
                    color: const Color(0xFF00B894),
                    textColor: textColor,
                    subColor: subTextColor),
                  _ComponentItem(
                    name: 'TDS Sensor',
                    desc: 'Total Dissolved Solids sensor',
                    color: const Color(0xFFFF9800),
                    textColor: textColor,
                    subColor: subTextColor),
                  _ComponentItem(
                    name: 'Firebase',
                    desc: 'Cloud platform for real-time data',
                    color: const Color(0xFFE53935),
                    textColor: textColor,
                    subColor: subTextColor),
                ],
              ),
              const SizedBox(height: 16),

              // Developer info
              _SectionCard(
                cardColor: cardColor,
                title: 'Developed By',
                titleColor: const Color(0xFF0077B6),
                children: [
                  _InfoText(
                    text: 'This application was developed as a project for the Application Development & Emerging Technologies subject.',
                    color: subTextColor),
                  const SizedBox(height: 10),
                  _InfoText(
                    text: 'Built with Flutter, Firebase, and ESP32 IoT technology.',
                    color: subTextColor),
                ],
              ),
              const SizedBox(height: 24),

              // Footer
              Center(
                child: Column(children: [
                  Text('Made with 💧 for clean water monitoring',
                    style: TextStyle(
                      fontSize: 12,
                      color: subTextColor)),
                  const SizedBox(height: 4),
                  Text('AquaMonitor © 2025',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400)),
                ]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Color cardColor;
  final String title;
  final Color titleColor;
  final List<Widget> children;
  const _SectionCard({
    required this.cardColor,
    required this.title,
    required this.titleColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: titleColor)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  final Color color;
  const _InfoText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontSize: 13,
        color: color,
        height: 1.6));
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
          style: const TextStyle(fontSize: 13))),
      ]),
    );
  }
}

class _ComponentItem extends StatelessWidget {
  final String name, desc;
  final Color color, textColor, subColor;
  const _ComponentItem({
    required this.name,
    required this.desc,
    required this.color,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor)),
            Text(desc,
              style: TextStyle(
                fontSize: 11,
                color: subColor)),
          ],
        ),
      ]),
    );
  }
}
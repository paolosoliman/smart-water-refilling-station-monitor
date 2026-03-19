import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tank_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WaterStationApp());
}

// ===== SHARED STATE =====
class AppState {
  static double waterLevel = 65;
  static double tds = 143;
  static double turbidity = 1.2;
  static String lastRefill = 'Mar 12, 08:30 AM';
  static List<Map<String, dynamic>> alerts = [];
  static List<Map<String, dynamic>> history = [];
}

class WaterStationApp extends StatefulWidget {
  const WaterStationApp({super.key});

  static _WaterStationAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_WaterStationAppState>();

  @override
  State<WaterStationApp> createState() => _WaterStationAppState();
}

class _WaterStationAppState extends State<WaterStationApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaMonitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B6),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFE),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

// ===== SPLASH SCREEN =====
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _pulseAnim;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));
    _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack)));
    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut)));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _mainController.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _showButton = true);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _getStarted() {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) =>
        user != null ? const MainNavigation() : const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF023E8A), Color(0xFF0077B6), Color(0xFF00B4D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -80, right: -80,
              child: Container(
                width: 280, height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05)),
              ),
            ),
            Positioned(
              bottom: -60, left: -60,
              child: Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05)),
              ),
            ),
            Positioned(
              top: 200, left: -40,
              child: Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04)),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Animated logo
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnim,
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: child,
                        ),
                      );
                    },
                    child: ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10)),
                          ],
                        ),
                        child: const Icon(
                          Icons.water_drop,
                          size: 64,
                          color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App name with animation
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnim,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnim.value),
                          child: child,
                        ),
                      );
                    },
                    child: Column(children: [
                      const Text('AquaMonitor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Text(
                          'Smart Water Refilling Station',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            letterSpacing: 0.5)),
                      ),
                    ]),
                  ),

                  const Spacer(flex: 2),

                  // Get Started button
                  AnimatedOpacity(
                    opacity: _showButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: AnimatedSlide(
                      offset: _showButton
                        ? Offset.zero
                        : const Offset(0, 0.3),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0077B6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                                elevation: 8,
                                shadowColor:
                                  Colors.black.withOpacity(0.3),
                              ),
                              onPressed: _getStarted,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Get Started',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded,
                                    size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Monitor your water station anytime, anywhere',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12)),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== MAIN NAVIGATION =====
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TankScreen(),
    AlertsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // This now properly reads isDarkMode on every build
    final isDark = WaterStationApp.of(context)?.isDarkMode ?? false;
    final navBgColor = isDark
      ? const Color(0xFF111827)
      : Colors.white;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4)),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) =>
            setState(() => _selectedIndex = i),
          backgroundColor: navBgColor,
          indicatorColor: isDark
            ? const Color(0xFF1E3A5A)
            : const Color(0xFFE3F2FD),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home,
                color: Color(0xFF0077B6)),
              label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.water_outlined),
              selectedIcon: Icon(Icons.water,
                color: Color(0xFF0077B6)),
              label: 'Tank'),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications,
                color: Color(0xFF0077B6)),
              label: 'Alerts'),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart,
                color: Color(0xFF0077B6)),
              label: 'History'),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person,
                color: Color(0xFF0077B6)),
              label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
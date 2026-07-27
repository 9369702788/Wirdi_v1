import 'package:flutter/material.dart';
import '../../features/home/home_dashboard_screen.dart';
import '../../features/prayer/prayer_times_screen.dart';
import '../../features/tasbeeh/tasbeeh_screen.dart';

/// Bottom navigation shell. Only screens included in this scaffold slice
/// (Home, Prayer, Tasbeeh) are wired up; Quran and Azkar tabs are stubbed
/// so the nav structure from the brief is visible end-to-end.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeDashboardScreen(),
    _StubScreen(title: 'القرآن', icon: Icons.menu_book_outlined),
    _StubScreen(title: 'الأذكار', icon: Icons.favorite_outline),
    PrayerTimesScreen(),
    TasbeehScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'القرآن'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'الأذكار'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'الصلاة'),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'التسبيح'),
        ],
      ),
    );
  }
}

class _StubScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const _StubScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text('$title — قريبًا في هذا الإصدار التجريبي'),
          ],
        ),
      ),
    );
  }
}

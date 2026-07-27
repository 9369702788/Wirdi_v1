import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class _Prayer {
  final String name;
  final String time;
  final bool isNext;
  const _Prayer(this.name, this.time, {this.isNext = false});
}

const _prayers = [
  _Prayer('الفجر', '04:32'),
  _Prayer('الظهر', '12:14'),
  _Prayer('العصر', '15:47', isNext: true),
  _Prayer('المغرب', '19:02'),
  _Prayer('العشاء', '20:31'),
];

/// Screen 14 — Prayer Times: next prayer, countdown, five prayers grid,
/// calculation method settings entry point.
class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
            tooltip: 'طريقة الحساب',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryEmerald, Color(0xFF115E56)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Text('العصر', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('01:42:10', style: TextStyle(color: AppColors.goldAccent, fontSize: 20, letterSpacing: 2)),
                SizedBox(height: 4),
                Text('الوقت المتبقي', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._prayers.map((p) => Card(
                color: p.isNext
                    ? AppColors.primaryEmerald.withOpacity(0.08)
                    : null,
                child: ListTile(
                  leading: Icon(
                    Icons.mosque_outlined,
                    color: p.isNext ? AppColors.primaryEmerald : AppColors.mutedText,
                  ),
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(
                    p.time,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: p.isNext ? AppColors.primaryEmerald : null,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

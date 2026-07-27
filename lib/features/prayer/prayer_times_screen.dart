import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayers = [
      {
        "name": "الفجر",
        "time": "04:32",
      },
      {
        "name": "الظهر",
        "time": "12:14",
      },
      {
        "name": "العصر",
        "time": "15:47",
        "next": true,
      },
      {
        "name": "المغرب",
        "time": "19:02",
      },
      {
        "name": "العشاء",
        "time": "20:31",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryEmerald,
                  Color(0xFF115E56),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Text(
                  'العصر',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '01:42:10',
                  style: TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'الوقت المتبقي',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...prayers.map(
            (p) => Card(
              child: ListTile(
                leading: Icon(
                  Icons.mosque_outlined,
                  color: p["next"] == true
                      ? AppColors.primaryEmerald
                      : AppColors.mutedText,
                ),
                title: Text(
                  p["name"] as String,
                ),
                trailing: Text(
                  p["time"] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: p["next"] == true
                        ? AppColors.primaryEmerald
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

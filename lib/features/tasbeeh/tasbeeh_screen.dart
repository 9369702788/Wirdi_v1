import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int count = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      count = prefs.getInt("count") ?? 0;
      total = prefs.getInt("total") ?? 0;
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("count", count);
    await prefs.setInt("total", total);
  }

  Future<void> increment() async {
    HapticFeedback.mediumImpact();

    setState(() {
      count++;
      total++;
    });

    await saveData();
  }

  Future<void> resetCounter() async {
    setState(() {
      count = 0;
    });

    await saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التسبيح"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetCounter,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            "$count",
            style: const TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "الإجمالي: $total",
            style: const TextStyle(
              fontSize: 22,
            ),
          ),

          const Spacer(),

          Center(
            child: GestureDetector(
              onTap: increment,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F766E),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "سبّح",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

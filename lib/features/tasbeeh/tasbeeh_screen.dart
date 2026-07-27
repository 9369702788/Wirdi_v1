import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int _count = 0;
  int _total = 0;

  String _selectedZekr = "سبحان الله";

  int _target = 33;

  final List<String> _azkar = [
    "سبحان الله",
    "الحمد لله",
    "الله أكبر",
    "لا إله إلا الله",
    "أستغفر الله",
    "سبحان الله وبحمده",
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _count = prefs.getInt('tasbeeh_count') ?? 0;
      _total = prefs.getInt('tasbeeh_total') ?? 0;

      _selectedZekr =
          prefs.getString('tasbeeh_zekr') ??
              "سبحان الله";

      _target =
          prefs.getInt('tasbeeh_target') ?? 33;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('tasbeeh_count', _count);
    await prefs.setInt('tasbeeh_total', _total);

    await prefs.setString(
      'tasbeeh_zekr',
      _selectedZekr,
    );

    await prefs.setInt(
      'tasbeeh_target',
      _target,
    );
  }

  Future<void> _increment() async {
    HapticFeedback.mediumImpact();

    setState(() {
      _count++;
      _total++;
    });

    if (_count == _target) {
      HapticFeedback.heavyImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ تم الوصول إلى $_target",
            ),
          ),
        );
      }
    }

    await _saveData();
  }

  Future<void> _reset() async {
    HapticFeedback.selectionClick();

    setState(() {
      _count = 0;
    });

    await _saveData();
  }

  Future<void> _changeTarget(int value) async {
    setState(() {
      _target = value;
    });

    await _saveData();
  }

  Future<void> _changeZekr(String value) async {
    setState(() {
      _selectedZekr = value;
    });

    await _saveData();
  }

  @override
  Widget build(BuildContext context) {

    final progress =
        (_count / _target).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("التسبيح"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15),
            child: DropdownButtonFormField<String>(
              value: _selectedZekr,
              items: _azkar.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _changeZekr(value);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "الذكر",
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _changeTarget(33),
                    child: const Text("33"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _changeTarget(100),
                    child: const Text("100"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _changeTarget(1000),
                    child: const Text("1000"),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(
                  label: 'اليوم',
                  value: '$_count',
                ),
                _StatChip(
                  label: 'الإجمالي',
                  value: '$_total',
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: 

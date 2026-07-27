import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

/// Screen 13 — Tasbeeh: minimal digital counter with haptic feedback
/// and daily/total stats.
class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int _count = 0;
  int _total = 128;

  void _increment() {
    HapticFeedback.mediumImpact();
    setState(() {
      _count++;
      _total++;
    });
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() => _count = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التسبيح'),
        actions: [
          IconButton(onPressed: _reset, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(label: 'اليوم', value: '$_count'),
                _StatChip(label: 'الإجمالي', value: '$_total'),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _increment,
                child: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    width: 220,
                    height: 220,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryEmerald, Color(0xFF115E56)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryEmerald.withOpacity(0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Text(
                      '$_count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Text('اضغط للتسبيح', style: TextStyle(color: AppColors.mutedText)),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryEmerald.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
        ],
      ),
    );
  }
}

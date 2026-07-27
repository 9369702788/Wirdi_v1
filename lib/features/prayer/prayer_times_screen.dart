import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../core/data/app_sources.dart';
import '../../core/theme/app_theme.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  bool _loading = true;
  String? _error;

  List<_PrayerItem> _prayers = [];
  String _nextPrayerName = '...';
  String _countdown = '--:--:--';

  Timer? _timer;
  DateTime? _nextPrayerTime;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final permissionReady = await _ensureLocationPermission();

      if (!permissionReady) {
        setState(() {
          _loading = false;
          _error = 'برجاء السماح للتطبيق باستخدام الموقع لعرض مواقيت الصلاة الحقيقية.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url = AppSources.prayerTimesUrl(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
          _error = 'تعذر تحميل مواقيت الصلاة. تحقق من اتصال الإنترنت.';
        });
        return;
      }

      final decoded = jsonDecode(response.body);

      final data = decoded['data'];
      final timings = data['timings'];

      final now = DateTime.now();

      final prayers = [
        _PrayerItem(
          name: 'الفجر',
          timeText: _cleanTime(timings['Fajr']),
          dateTime: _timeToday(_cleanTime(timings['Fajr']), now),
        ),
        _PrayerItem(
          name: 'الظهر',
          timeText: _cleanTime(timings['Dhuhr']),
          dateTime: _timeToday(_cleanTime(timings['Dhuhr']), now),
        ),
        _PrayerItem(
          name: 'العصر',
          timeText: _cleanTime(timings['Asr']),
          dateTime: _timeToday(_cleanTime(timings['Asr']), now),
        ),
        _PrayerItem(
          name: 'المغرب',
          timeText: _cleanTime(timings['Maghrib']),
          dateTime: _timeToday(_cleanTime(timings['Maghrib']), now),
        ),
        _PrayerItem(
          name: 'العشاء',
          timeText: _cleanTime(timings['Isha']),
          dateTime: _timeToday(_cleanTime(timings['Isha']), now),
        ),
      ];

      final next = _getNextPrayer(prayers, now);

      setState(() {
        _prayers = prayers;
        _nextPrayerName = next.name;
        _nextPrayerTime = next.dateTime;
        _loading = false;
      });

      _startCountdown();
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'حدث خطأ أثناء تحميل مواقيت الصلاة.';
      });
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  String _cleanTime(dynamic value) {
    final text = value.toString();

    if (text.contains(' ')) {
      return text.split(' ').first;
    }

    return text;
  }

  DateTime _timeToday(String value, DateTime now) {
    final parts = value.split(':');

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }

  _PrayerItem _getNextPrayer(
    List<_PrayerItem> prayers,
    DateTime now,
  ) {
    for (final prayer in prayers) {
      if (prayer.dateTime.isAfter(now)) {
        return prayer.copyWith(isNext: true);
      }
    }

    final fajrTomorrow = prayers.first.dateTime.add(
      const Duration(days: 1),
    );

    return _PrayerItem(
      name: 'الفجر',
      timeText: prayers.first.timeText,
      dateTime: fajrTomorrow,
      isNext: true,
    );
  }

  void _startCountdown() {
    _timer?.cancel();

    _updateCountdown();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _updateCountdown();
      },
    );
  }

  void _updateCountdown() {
    final target = _nextPrayerTime;

    if (target == null) {
      return;
    }

    final now = DateTime.now();

    Duration diff = target.difference(now);

    if (diff.isNegative) {
      _loadPrayerTimes();
      return;
    }

    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

    if (mounted) {
      setState(() {
        _countdown = '$hours:$minutes:$seconds';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('مواقيت الصلاة'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_off_outlined,
                  size: 52,
                  color: AppColors.mutedText,
                ),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadPrayerTimes,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadPrayerTimes,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryEmerald,
                  Color(0xFF115E56),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  'الصلاة القادمة',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _nextPrayerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _countdown,
                  style: const TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'الوقت المتبقي',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ..._prayers.map(
            (prayer) {
              final isNext = prayer.name == _nextPrayerName;

              return Card(
                color: isNext
                    ? AppColors.primaryEmerald.withValues(alpha: 0.08)
                    : null,
                child: ListTile(
                  leading: Icon(
                    Icons.mosque_outlined,
                    color: isNext
                        ? AppColors.primaryEmerald
                        : AppColors.mutedText,
                  ),
                  title: Text(
                    prayer.name,
                    style: TextStyle(
                      fontWeight: isNext
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    prayer.timeText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isNext
                          ? AppColors.primaryEmerald
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'ملاحظة: المواقيت تعتمد على موقع الهاتف وخدمة AlAdhan بطريقة الحساب المصرية.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerItem {
  final String name;
  final String timeText;
  final DateTime dateTime;
  final bool isNext;

  const _PrayerItem({
    required this.name,
    required this.timeText,
    required this.dateTime,
    this.isNext = false,
  });

  _PrayerItem copyWith({
    String? name,
    String? timeText,
    DateTime? dateTime,
    bool? isNext,
  }) {
    return _PrayerItem(
      name: name ?? this.name,
      timeText: timeText ?? this.timeText,
      dateTime: dateTime ?? this.dateTime,
      isNext: isNext ?? this.isNext,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  bool _loading = true;

  String _city = "موقعي الحالي";

  final List<_PrayerItem> _prayers = [];

  String _nextPrayer = "...";

  String _countDown = "...";

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final position =
          await Geolocator.getCurrentPosition();

      final coordinates = Coordinates(
        position.latitude,
        position.longitude,
      );

      final params =
          CalculationMethod.egyptian.getParameters();

      final date = DateComponents.from(
        DateTime.now(),
      );

      final prayerTimes = PrayerTimes(
        coordinates,
        date,
        params,
      );

      final prayers = [
        _PrayerItem(
          "الفجر",
          _format(prayerTimes.fajr),
        ),
        _PrayerItem(
          "الظهر",
          _format(prayerTimes.dhuhr),
        ),
        _PrayerItem(
          "العصر",
          _format(prayerTimes.asr),
        ),
        _PrayerItem(
          "المغرب",
          _format(prayerTimes.maghrib),
        ),
        _PrayerItem(
          "العشاء",
          _format(prayerTimes.isha),
        ),
      ];

      Prayer? next =
          prayerTimes.nextPrayer();

      String nextName = "لا يوجد";

      DateTime? nextTime;

      if (next == Prayer.fajr) {
        nextName = "الفجر";
        nextTime = prayerTimes.fajr;
      }

      if (next == Prayer.dhuhr) {
        nextName = "الظهر";
        nextTime = prayerTimes.dhuhr;
      }

      if (next == Prayer.asr) {
        nextName = "العصر";
        nextTime = prayerTimes.asr;
      }

      if (next == Prayer.maghrib) {
        nextName = "المغرب";
        nextTime = prayerTimes.maghrib;
      }

      if (next == Prayer.isha) {
        nextName = "العشاء";
        nextTime = prayerTimes.isha;
      }

      final remain =
          nextTime!.difference(DateTime.now());

      final h =
          remain.inHours.toString().padLeft(2, "0");

      final m = (remain.inMinutes % 60)
          .toString()
          .padLeft(2, "0");

      final s = (remain.inSeconds % 60)
          .toString()
          .padLeft(2, "0");

      setState(() {
        _prayers.clear();
        _prayers.addAll(prayers);

        _nextPrayer = nextName;

        _countDown = "$h:$m:$s";

        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }

  String _format(DateTime date) {
    final hh =
        date.hour.toString().padLeft(2, '0');

    final mm =
        date.minute.

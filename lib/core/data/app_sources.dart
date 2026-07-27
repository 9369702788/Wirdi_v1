class AppSources {
  static const String quranJsonUrl =
      'https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran.json';

  static const String azkarJsonUrl =
      'https://raw.githubusercontent.com/YousefAsalya/Islamic-Pro-azkar-API/main/data/ar.json';

  static const String everyAyahBaseUrl =
      'https://everyayah.com/data';

  static const String defaultReciter =
      'Alafasy_64kbps';

  static String getAyahAudio({
    required int surah,
    required int ayah,
  }) {
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');

    return '$everyAyahBaseUrl/$defaultReciter/$s$a.mp3';
  }

  static const String licenses = '''
Quran Text:
Tanzil Project

Audio:
EveryAyah

Azkar:
Hisn Al Muslim
''';
}

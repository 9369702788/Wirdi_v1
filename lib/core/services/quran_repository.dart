import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/app_sources.dart';
import '../models/quran_models.dart';

class QuranRepository {
  static Future<List<SurahModel>> loadQuran() async {
    final response =
        await http.get(Uri.parse(AppSources.quranJsonUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Quran');
    }

    final data = jsonDecode(response.body);

    final List<SurahModel> result = [];

    for (final item in data) {
      final verses = <AyahModel>[];

      for (final verse in item['verses']) {
        verses.add(
          AyahModel(
            number: verse['id'],
            text: verse['text'],
          ),
        );
      }

      result.add(
        SurahModel(
          number: item['id'],
          name: item['name'],
          englishName: item['transliteration'],
          ayahs: verses,
        ),
      );
    }

    return result;
  }
}

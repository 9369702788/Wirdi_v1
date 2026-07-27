import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/app_sources.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<List<SurahData>> _future;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = QuranApi.loadQuran();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SurahData>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _ErrorView(
              message: 'تعذر تحميل القرآن الكريم. تأكد من اتصال الإنترنت.',
              onRetry: () {
                setState(() {
                  _future = QuranApi.loadQuran();
                });
              },
            );
          }

          final allSurahs = snapshot.data!;
          final query = _searchController.text.trim();

          final filtered = allSurahs.where((surah) {
            if (query.isEmpty) return true;

            return surah.name.contains(query) ||
                surah.number.toString() == query ||
                surah.transliteration.toLowerCase().contains(
                      query.toLowerCase(),
                    );
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم السورة أو رقمها',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final surah = filtered[index];

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE6F3F1),
                          child: Text(
                            '${surah.number}',
                            style: const TextStyle(
                              color: Color(0xFF0F766E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          surah.name,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          '${surah.transliteration} - ${surah.ayahs.length} آية',
                          textAlign: TextAlign.right,
                        ),
                        trailing: const Icon(Icons.menu_book),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurahReaderScreen(
                                surah: surah,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SurahReaderScreen extends StatefulWidget {
  final SurahData surah;

  const SurahReaderScreen({
    super.key,
    required this.surah,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  final Set<int> _favoriteAyahs = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _saveLastReading(int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'last_surah_number',
      widget.surah.number,
    );

    await prefs.setString(
      'last_surah_name',
      widget.surah.name,
    );

    await prefs.setInt(
      'last_ayah_number',
      ayahNumber,
    );
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final key = 'favorite_ayahs_${widget.surah.number}';
    final saved = prefs.getStringList(key) ?? [];

    setState(() {
      _favoriteAyahs.clear();
      _favoriteAyahs.addAll(
        saved.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0),
      );
    });
  }

  Future<void> _toggleFavorite(int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_favoriteAyahs.contains(ayahNumber)) {
        _favoriteAyahs.remove(ayahNumber);
      } else {
        _favoriteAyahs.add(ayahNumber);
      }
    });

    final key = 'favorite_ayahs_${widget.surah.number}';

    await prefs.setStringList(
      key,
      _favoriteAyahs.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _bookmark(int ayahNumber) async {
    await _saveLastReading(ayahNumber);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ آخر قراءة: سورة ${widget.surah.name} - آية $ayahNumber',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surah = widget.surah;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      appBar: AppBar(
        title: Text('سورة ${surah.name}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F766E),
                  Color(0xFF115E56),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  'سورة ${surah.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${surah.ayahs.length} آية',
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...surah.ayahs.map((ayah) {
            final isFavorite = _favoriteAyahs.contains(ayah.number);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${ayah.text}  ﴿${ayah.number}﴾',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _bookmark(ayah.number);
                          },
                          icon: const Icon(
                            Icons.bookmark_border,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _toggleFavorite(ayah.number);
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'آية ${ayah.number}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class QuranApi {
  static Future<List<SurahData>> loadQuran() async {
    final response = await http.get(
      Uri.parse(AppSources.quranJsonUrl),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load Quran');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Unexpected Quran JSON format');
    }

    return decoded.map<SurahData>((item) {
      final map = item as Map<String, dynamic>;

      final versesRaw = map['verses'] as List<dynamic>;

      final ayahs = versesRaw.map<AyahData>((verse) {
        final verseMap = verse as Map<String, dynamic>;

        return AyahData(
          number: _readInt(
            verseMap,
            ['id', 'number'],
          ),
          text: _readString(
            verseMap,
            ['text'],
          ),
        );
      }).toList();

      return SurahData(
        number: _readInt(
          map,
          ['id', 'number'],
        ),
        name: _readString(
          map,
          ['name'],
        ),
        transliteration: _readString(
          map,
          ['transliteration'],
        ),
        ayahs: ayahs,
      );
    }).toList();
  }

  static int _readInt(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = map[key];

      if (value is int) {
        return value;
      }

      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
    }

    return 0;
  }

  static String _readString(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = map[key];

      if (value != null) {
        return value.toString();
      }
    }

    return '';
  }
}

class SurahData {
  final int number;
  final String name;
  final String transliteration;
  final List<AyahData> ayahs;

  const SurahData({
    required this.number,
    required this.name,
    required this.transliteration,
    required this.ayahs,
  });
}

class AyahData {
  final int number;
  final String text;

  const AyahData({
    required this.number,
    required this.text,
  });
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Color(0xFF64748B),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

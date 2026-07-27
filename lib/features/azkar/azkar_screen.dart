import 'package:flutter/material.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  final Map<String, List<Map<String, dynamic>>> azkar = {
    "أذكار الصباح": [
      {
        "text":
            "أصبحنا وأصبح الملك لله والحمد لله لا إله إلا الله وحده لا شريك له",
        "count": 1
      },
      {
        "text":
            "اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك النشور",
        "count": 1
      },
      {
        "text": "سبحان الله وبحمده",
        "count": 100
      },
    ],
    "أذكار المساء": [
      {
        "text":
            "أمسينا وأمسى الملك لله والحمد لله لا إله إلا الله وحده لا شريك له",
        "count": 1
      },
      {
        "text":
            "اللهم بك أمسينا وبك أصبحنا وبك نحيا وبك نموت وإليك المصير",
        "count": 1
      },
      {
        "text":
            "أعوذ بكلمات الله التامات من شر ما خلق",
        "count": 3
      },
    ],
    "أذكار النوم": [
      {
        "text":
            "باسمك اللهم أموت وأحيا",
        "count": 1
      },
      {
        "text":
            "اللهم قني عذابك يوم تبعث عبادك",
        "count": 3
      },
    ],
    "أذكار الاستيقاظ": [
      {
        "text":
            "الحمد لله الذي أحيانا بعدما أماتنا وإليه النشور",
        "count": 1
      },
    ],
    "أذكار بعد الصلاة": [
      {
        "text": "أستغفر الله",
        "count": 3
      },
      {
        "text":
            "اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام",
        "count": 1
      },
      {
        "text": "سبحان الله",
        "count": 33
      },
      {
        "text": "الحمد لله",
        "count": 33
      },
      {
        "text": "الله أكبر",
        "count": 33
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final categories = azkar.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("الأذكار"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(
                category,
                textAlign: TextAlign.right,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AzkarDetailsScreen(
                      title: category,
                      items: azkar[category]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AzkarDetailsScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const AzkarDetailsScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<AzkarDetailsScreen> createState() =>
      _AzkarDetailsScreenState();
}

class _AzkarDetailsScreenState
    extends State<AzkarDetailsScreen> {
  final Map<int, int> counters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final zekr = widget.items[index];

          final target = zekr["count"] as int;
          final current = counters[index] ?? 0;

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    zekr["text"],
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "$current / $target",
     

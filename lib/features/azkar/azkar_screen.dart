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
    ],
    "أذكار المساء": [
      {
        "text":
            "أمسينا وأمسى الملك لله والحمد لله لا إله إلا الله وحده لا شريك له",
        "count": 1
      },
    ],
    "أذكار النوم": [
      {
        "text": "باسمك اللهم أموت وأحيا",
        "count": 1
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
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(category),
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
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$current / $target",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        counters[index] = current + 1;
                      });
                    },
                    child: const Text("تسبيح"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

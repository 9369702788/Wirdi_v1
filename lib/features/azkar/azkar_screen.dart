import 'package:flutter/material.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "أذكار الصباح",
      "أذكار المساء",
      "أذكار النوم",
      "أذكار الاستيقاظ",
      "أذكار بعد الصلاة",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("الأذكار"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: Text(
                categories[index],
                textAlign: TextAlign.right,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}

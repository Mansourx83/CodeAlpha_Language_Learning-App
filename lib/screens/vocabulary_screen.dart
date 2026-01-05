import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// استورد ملف الألوان الخاص بك هنا

class VocabularyScreen extends StatelessWidget {
  VocabularyScreen({super.key});

  // بيانات تجريبية (سننقلها لقاعدة البيانات لاحقاً)
  final List<Map<String, String>> words = [
    {'word': 'Enthusiasm', 'translation': 'حماس'},
    {'word': 'Persistence', 'translation': 'إصرار'},
    {'word': 'Achievement', 'translation': 'إنجاز'},
    {'word': 'Challenge', 'translation': 'تحدي'},
    {'word': 'Success', 'translation': 'نجاح'},
  ];

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(
          'Vocabulary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text(
                words[index]['word']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              subtitle: Text(
                words[index]['translation']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: Color(0xFF4A90E2),
                  size: 28,
                ),
                onPressed: () => _speak(words[index]['word']!),
              ),
            ),
          );
        },
      ),
    );
  }
}

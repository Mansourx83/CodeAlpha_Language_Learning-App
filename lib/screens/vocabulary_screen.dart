import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_learning/app_colors.dart';
import 'package:language_learning/services/database_helper.dart';

class VocabularyScreen extends StatefulWidget {
  final String category;
  final String level;

  const VocabularyScreen({
    super.key,
    required this.category,
    required this.level,
  });

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.speak(text);
  }

  void _deleteWord(int id) async {
    await DatabaseHelper.instance.deleteWord(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              widget.level,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getWordsByCategoryAndLevel(
          widget.category,
          widget.level,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _EmptyState();
          }

          final words = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: words.length,
            itemBuilder: (context, index) {
              final item = words[index];
              return _VocabularyCard(
                word: item['word'],
                translation: item['translation'],
                onSpeak: () => _speak(item['word']),
                onDelete: widget.level == "Custom"
                    ? () => _showDeleteDialog(item['id'], item['word'])
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(int id, String word) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete word"),
        content: Text("Are you sure you want to delete \"$word\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _deleteWord(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _VocabularyCard extends StatelessWidget {
  final String word;
  final String translation;
  final VoidCallback onSpeak;
  final VoidCallback? onDelete;

  const _VocabularyCard({
    required this.word,
    required this.translation,
    required this.onSpeak,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.vocab.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.translate, color: AppColors.vocab),
          ),
          const SizedBox(width: 16),

          // Word & Translation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  translation,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.volume_up_rounded),
                color: AppColors.vocab,
                onPressed: onSpeak,
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "No words yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Start adding new vocabulary ✨",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

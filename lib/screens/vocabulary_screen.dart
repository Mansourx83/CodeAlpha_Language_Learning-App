import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_learning/app_colors.dart';
import 'package:language_learning/services/database_helper.dart';

class VocabularyScreen extends StatefulWidget {
  final String category; // لاستقبال نوع القسم (Vocabulary أو Grammar أو Phrases)
  const VocabularyScreen({super.key, required this.category});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  void _deleteWord(int id) async {
    // تفعيل الحذف الفعلي من قاعدة البيانات
    await DatabaseHelper.instance.deleteWord(id); 
    setState(() {}); // إعادة بناء الواجهة لتحديث القائمة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.category, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // جلب البيانات بناءً على القسم المختار فقط
        future: DatabaseHelper.instance.getWordsByCategory(widget.category), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("No items in ${widget.category} yet.", 
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          final words = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: words.length,
            itemBuilder: (context, index) {
              final item = words[index];
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(
                    item['word'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  subtitle: Text(
                    item['translation'],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.vocab),
                        onPressed: () => _speak(item['word']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => _showDeleteDialog(item['id'], item['word']),
                      ),
                    ],
                  ),
                ),
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
        title: const Text("Delete Word?"),
        content: Text("Are you sure you want to delete '$word'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              _deleteWord(id);
              Navigator.pop(context);
            }, 
            child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
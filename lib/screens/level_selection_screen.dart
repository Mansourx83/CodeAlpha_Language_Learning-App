import 'package:flutter/material.dart';
import 'package:language_learning/app_colors.dart';
import 'package:language_learning/screens/vocabulary_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final String category;
  const LevelSelectionScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // المستويات المتاحة في قاعدة البيانات التي أنشأناها
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'Custom'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Select $category Level"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              title: Text(levels[index], 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              subtitle: Text(levels[index] == 'Custom' ? "Words added by you" : "Standardized curriculum"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VocabularyScreen(
                      category: category,
                      level: levels[index],
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
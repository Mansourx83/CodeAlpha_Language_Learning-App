import 'package:flutter/material.dart';
import 'package:language_learning/app_colors.dart';
import 'quiz_play_screen.dart'; // تأكد من إنشاء هذا الملف كما في الرد السابق

class QuizLevelScreen extends StatelessWidget {
  const QuizLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Quiz Levels")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPlayScreen(level: levels[index]),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.vocab,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  levels[index],
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:language_learning/app_colors.dart';
import 'package:language_learning/screens/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Vocabulary',
        'icon': Icons.translate,
        'gradient': AppColors.vocabGradient,
      },
      {
        'title': 'Grammar',
        'icon': Icons.menu_book_rounded,
        'gradient': AppColors.grammarGradient,
      },
      {
        'title': 'Phrases',
        'icon': Icons.forum_rounded,
        'gradient': AppColors.phrasesGradient,
      },
      {
        'title': 'Daily Quiz',
        'icon': Icons.auto_awesome,
        'gradient': AppColors.quizGradient,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Lingo Master",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      title: categories[index]['title'],
                      icon: categories[index]['icon'],
                      gradient: categories[index]['gradient'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

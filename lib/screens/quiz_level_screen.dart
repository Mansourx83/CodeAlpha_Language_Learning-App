import 'package:flutter/material.dart';
import 'package:language_learning/app_colors.dart';
import 'quiz_play_screen.dart';

class QuizLevelScreen extends StatelessWidget {
  const QuizLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تعريف المستويات مع وصف بسيط لكل مستوى لزيادة جمالية الكارت
    final List<Map<String, String>> levels = [
      {'id': 'A1', 'desc': 'Beginner'},
      {'id': 'A2', 'desc': 'Elementary'},
      {'id': 'B1', 'desc': 'Intermediate'},
      {'id': 'B2', 'desc': 'Upper-Int'},
      {'id': 'C1', 'desc': 'Advanced'},
      {'id': 'C2', 'desc': 'Mastery'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar جذاب ومنحني
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Select Level",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildLevelCard(context, levels[index]);
              }, childCount: levels.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, Map<String, String> level) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPlayScreen(level: level['id']!),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // دائرة خلفية للأيقونة أو الحرف
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.quiz.withOpacity(0.7), AppColors.quiz],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.quiz.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    level['id']!,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                level['desc']!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.quiz.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

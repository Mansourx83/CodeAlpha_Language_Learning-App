import 'package:flutter/material.dart';
import 'package:language_learning/screens/level_selection_screen.dart';
import 'package:language_learning/screens/quiz_level_screen.dart'; 

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (title == 'Daily Quiz') {
              // نذهب لصفحة تطلب منه اختيار مستوى الامتحان
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizLevelScreen()),
              );
            } else {
              // نذهب لصفحة تطلب منه اختيار المستوى (A1, A2, Custom...) قبل عرض الكلمات
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LevelSelectionScreen(category: title),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
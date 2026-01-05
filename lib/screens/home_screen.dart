import 'package:flutter/material.dart';
import 'package:language_learning/app_colors.dart';
import 'package:language_learning/screens/add_word_screen.dart';
import 'package:language_learning/screens/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Vocabulary',
        'icon': Icons.translate_rounded,
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
        'icon': Icons.auto_awesome_rounded,
        'gradient': AppColors.quizGradient,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      // زر الإضافة بتصميم عصري
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddWordScreen()),
        ),
        backgroundColor: AppColors.vocab,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Word",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // الهيدر الاحترافي
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back 👋",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Lingo Master",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF007AFF), Color(0xFF00C6FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF007AFF).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3), // مسافة الإطار الملون
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            'https://static0.thegamerimages.com/wordpress/wp-content/uploads/2025/03/untitled-design-2-1.jpg?w=1600&h=900&fit=crop',
                            fit: BoxFit.cover,
                            // إضافة Placeholder في حال تأخر التحميل
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // كارت التذكير اليومي (إضافة جمالية)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_circle,
                      color: Colors.orange,
                      size: 40,
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "You've learned 15 new words this week. Keep it up!",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),

            // شبكة الأقسام
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CategoryCard(
                    title: categories[index]['title'],
                    icon: categories[index]['icon'],
                    gradient: categories[index]['gradient'],
                  ),
                  childCount: categories.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

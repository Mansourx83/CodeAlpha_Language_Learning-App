import 'package:flutter/material.dart';
import 'package:language_learning/app_colors.dart';
import 'package:language_learning/screens/vocabulary_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final String category;
  const LevelSelectionScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // قائمة المستويات مع أيقونات تعبيرية
    final List<Map<String, dynamic>> levels = [
      {'id': 'A1', 'title': 'Beginner', 'icon': Icons.star_border_rounded},
      {'id': 'A2', 'title': 'Elementary', 'icon': Icons.star_half_rounded},
      {'id': 'B1', 'title': 'Intermediate', 'icon': Icons.star_rounded},
      {
        'id': 'B2',
        'title': 'Upper-Int',
        'icon': Icons.workspace_premium_rounded,
      },
      {'id': 'C1', 'title': 'Advanced', 'icon': Icons.auto_awesome_rounded},
      {'id': 'C2', 'title': 'Mastery', 'icon': Icons.military_tech_rounded},
      {'id': 'Custom', 'title': 'My Words', 'icon': Icons.edit_note_rounded},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header جذاب بأسلوب Slivers
          SliverAppBar(
            scrolledUnderElevation: 0,
            expandedHeight: 150,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "$category Levels",
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.05),
                      AppColors.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // قائمة المستويات
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final level = levels[index];
                bool isCustom = level['id'] == 'Custom';

                return _buildLevelItem(context, level, isCustom);
              }, childCount: levels.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildLevelItem(
    BuildContext context,
    Map<String, dynamic> level,
    bool isCustom,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isCustom ? Colors.blueAccent.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCustom
              ? Colors.blueAccent.withOpacity(0.2)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VocabularyScreen(category: category, level: level['id']),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // أيقونة المستوى
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCustom ? Colors.blueAccent : Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    level['icon'],
                    color: isCustom ? Colors.white : Colors.blueGrey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                // النصوص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level['id'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        level['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                // سهم الانتقال
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
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
  String _searchQuery = "";
  bool _isSearching = false;

  // تحديد اللون الثيم بناءً على المستوى عشان يطقم مع شاشة الليفلات
  Color _getLevelColor() {
    switch (widget.level) {
      case 'A1':
        return Colors.blue;
      case 'A2':
        return Colors.cyan;
      case 'B1':
        return Colors.teal;
      case 'B2':
        return Colors.indigo;
      case 'C1':
        return Colors.purple;
      case 'C2':
        return Colors.amber;
      case 'Custom':
        return Colors.pink;
      default:
        return AppColors.vocab;
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.speak(text);
  }

  void _deleteWord(int id) async {
    await DatabaseHelper.instance.deleteWord(id);
    setState(() {}); // تحديث القائمة بعد الحذف
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = _getLevelColor();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // خلفية بلمسات ضبابية (Blobs)
          Positioned(
            top: -50,
            left: -50,
            child: _buildBlob(150, themeColor.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildBlob(200, themeColor.withOpacity(0.05)),
          ),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.getWordsByCategoryAndLevel(
              widget.category,
              widget.level,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // معالجة البيانات والبحث
              final allWords = snapshot.data ?? [];
              final filteredWords = allWords.where((item) {
                final word = item['word'].toString().toLowerCase();
                final trans = item['translation'].toString().toLowerCase();
                final query = _searchQuery.toLowerCase();
                return word.contains(query) || trans.contains(query);
              }).toList();

              if (allWords.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    _buildModernAppBar(themeColor),
                    const SliverFillRemaining(child: _EmptyState()),
                  ],
                );
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildModernAppBar(themeColor),

                  if (filteredWords.isEmpty && _isSearching)
                    const SliverFillRemaining(
                      child: Center(child: Text("No matches found.")),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildAnimatedWordCard(
                            filteredWords[index],
                            index,
                            themeColor,
                          ),
                          childCount: filteredWords.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // تأثير الدوائر الملونة في الخلفية
  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(),
      ),
    );
  }

  // AppBar المودرن مع خاصية البحث
  Widget _buildModernAppBar(Color themeColor) {
    return SliverAppBar(
      expandedHeight: 150,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      leading: const BackButton(color: AppColors.textDark),
      actions: [
        IconButton(
          onPressed: () => setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) _searchQuery = "";
          }),
          icon: Icon(
            _isSearching ? Icons.close_rounded : Icons.search_rounded,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _isSearching
            ? _buildSearchField()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.category,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.level,
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
        background: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        autofocus: true,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
        decoration: const InputDecoration(
          hintText: "Search vocabulary...",
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  // أنيميشن ظهور الكروت
  Widget _buildAnimatedWordCard(
    Map<String, dynamic> item,
    int index,
    Color themeColor,
  ) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: _buildWordCard(item, themeColor),
          ),
        );
      },
    );
  }

  // تصميم الكارت نفسه
  Widget _buildWordCard(Map<String, dynamic> item, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _speak(item['word']),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [themeColor.withOpacity(0.7), themeColor],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['word'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['translation'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.level == "Custom")
                    IconButton(
                      onPressed: () =>
                          _showDeleteDialog(item['id'], item['word']),
                      icon: Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.red[300],
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(int id, String word) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text(
          "Remove Word?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Delete \"$word\" from your list?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _deleteWord(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// كلاس الـ Empty State المصحح والرووش
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
              const Icon(
                Icons.auto_stories_rounded,
                size: 70,
                color: Colors.blueAccent,
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            "No words here yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Start adding new vocabulary! 🚀",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

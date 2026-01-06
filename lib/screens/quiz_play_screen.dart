import 'package:flutter/material.dart';
import 'dart:math';
import '../app_colors.dart';
import '../services/database_helper.dart';

class QuizPlayScreen extends StatefulWidget {
  final String level;
  const QuizPlayScreen({super.key, required this.level});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  List<Map<String, dynamic>> _quizData = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  String? _selected;
  bool _answered = false;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final allWords = await DatabaseHelper.instance.getAllWords();
    final filtered = allWords.where((e) => e['level'] == widget.level).toList();

    if (filtered.length < 4) {
      setState(() => _isLoading = false);
      return;
    }

    filtered.shuffle();
    setState(() {
      _quizData = filtered.take(10).toList();
      _isLoading = false;
      _generateOptions(); // توليد الخيارات لأول سؤال
    });
  }

  void _generateOptions() {
    final current = _quizData[_currentIndex];
    List<String> options = [current['translation']];
    final random = Random();

    while (options.length < 4) {
      final candidate =
          _quizData[random.nextInt(_quizData.length)]['translation'];
      if (!options.contains(candidate)) options.add(candidate);
    }
    options.shuffle();
    _shuffledOptions = options;
  }

  void _answer(String selected) {
    if (_answered) return;
    final correct = _quizData[_currentIndex]['translation'];

    setState(() {
      _selected = selected;
      _answered = true;
      if (selected == correct) _score++;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        if (_currentIndex < _quizData.length - 1) {
          setState(() {
            _currentIndex++;
            _selected = null;
            _answered = false;
            _generateOptions();
          });
        } else {
          _showResult();
        }
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "🎊 Great Job!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.quiz.withOpacity(0.1),
                child: Text(
                  "$_score/${_quizData.length}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.quiz,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.quiz,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // قفل الديالوج
                  Navigator.pop(context); // رجوع للهوم
                },
                child: const Text(
                  "Back to Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_quizData.isEmpty)
      return const Scaffold(body: Center(child: Text("Not enough data.")));

    final current = _quizData[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        scrolledUnderElevation: 0,

        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Quiz: ${widget.level}",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Custom Progress Bar
            const SizedBox(height: 10),
            _buildProgressBar(),

            const SizedBox(height: 20),

            // Question Card with Animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _buildQuestionCard(current, key: ValueKey(_currentIndex)),
            ),

            const SizedBox(height: 40),

            // Options List
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: _shuffledOptions
                    .map((opt) => _buildOption(opt, current['translation']))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    double progress = (_currentIndex + 1) / _quizData.length;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Question ${_currentIndex + 1}/${_quizData.length}",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Score: $_score",
              style: const TextStyle(
                color: AppColors.quiz,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation(AppColors.quiz),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> current, {required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Translate this word",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 15),
          Text(
            current['word'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String opt, String correct) {
    bool isSelected = _selected == opt;
    bool isCorrect = opt == correct;

    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;
    IconData? icon;

    if (_answered) {
      if (isCorrect) {
        bgColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        icon = Icons.check_circle_rounded;
      } else if (isSelected) {
        bgColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        icon = Icons.cancel_rounded;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _answer(opt),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          opt,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _answered && isSelected ? borderColor : AppColors.textDark,
          ),
        ),
        trailing: icon != null ? Icon(icon, color: borderColor) : null,
      ),
    );
  }
}

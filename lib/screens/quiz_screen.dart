import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../services/database_helper.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _allWords = [];
  int _currentIndex = 0;
  int _score = 0;
  List<String> _options = [];
  bool _isLoading = true;

  String? _selectedAnswer;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  void _loadQuizData() async {
    final data = await DatabaseHelper.instance.getAllWords();
    if (data.length < 4) {
      _showWarningDialog();
      return;
    }
    setState(() {
      _allWords = List.from(data)..shuffle();
      _generateOptions();
      _isLoading = false;
    });
  }

  void _generateOptions() {
    String correct = _allWords[_currentIndex]['translation'];
    List<String> others =
        _allWords
            .where((w) => w['translation'] != correct)
            .map((w) => w['translation'].toString())
            .toList()
          ..shuffle();

    _options = [correct, ...others.take(3)]..shuffle();
    _selectedAnswer = null;
    _answered = false;
  }

  void _checkAnswer(String selected) {
    if (_answered) return;

    bool isCorrect = selected == _allWords[_currentIndex]['translation'];

    setState(() {
      _selectedAnswer = selected;
      _answered = true;
      if (isCorrect) _score++;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (_currentIndex < _allWords.length - 1 && _currentIndex < 9) {
        setState(() {
          _currentIndex++;
          _generateOptions();
        });
      } else {
        _showResult();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalQuestions = _allWords.length > 10 ? 10 : _allWords.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,

        elevation: 0,
        centerTitle: true,
        title: const Text("Daily Quiz"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              backgroundColor: AppColors.quiz.withOpacity(0.15),
              label: Text(
                "Score: $_score",
                style: const TextStyle(
                  color: AppColors.quiz,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${_currentIndex + 1}/$totalQuestions",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / totalQuestions,
                        minHeight: 8,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.quiz,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // Word Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 45),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.quizGradient),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.quiz.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _allWords[_currentIndex]['word'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // Options
            ..._options.map((opt) {
              final correct = _allWords[_currentIndex]['translation'];
              final isSelected = opt == _selectedAnswer;
              final isCorrect = opt == correct;

              Color bgColor = Colors.white;
              Color textColor = AppColors.textDark;

              if (_answered && isSelected) {
                bgColor = isCorrect ? Colors.green : Colors.redAccent;
                textColor = Colors.white;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 14),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundColor: bgColor,
                    foregroundColor: textColor,
                    elevation: isSelected ? 6 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _answered ? null : () => _checkAnswer(opt),
                  child: Text(opt, style: const TextStyle(fontSize: 18)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("🎉 Quiz Completed"),
        content: Text(
          "Your score: $_score / ${_currentIndex + 1}",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              Navigator.pop(context);
            },
            child: const Text("Back Home"),
          ),
        ],
      ),
    );
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Not enough words"),
        content: const Text("Please add at least 4 words to start a quiz."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Back"),
          ),
        ],
      ),
    ).then((_) => Navigator.pop(context));
  }
}

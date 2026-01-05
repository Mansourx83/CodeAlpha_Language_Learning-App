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
    String correctAnswer = _allWords[_currentIndex]['translation'];
    List<String> others = _allWords
        .where((w) => w['translation'] != correctAnswer)
        .map((w) => w['translation'].toString())
        .toList();
    others.shuffle();

    _options = [correctAnswer, ...others.take(3)];
    _options.shuffle();
  }

  void _checkAnswer(String selected) {
    bool isCorrect = selected == _allWords[_currentIndex]['translation'];
    if (isCorrect) _score++;

    if (_currentIndex < _allWords.length - 1 && _currentIndex < 9) {
      // حد أقصى 10 أسئلة
      setState(() {
        _currentIndex++;
        _generateOptions();
      });
    } else {
      _showResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Daily Quiz"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value:
                  (_currentIndex + 1) /
                  (_allWords.length > 10 ? 10 : _allWords.length),
              backgroundColor: Colors.white,
              color: AppColors.quiz,
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.quizGradient),
                borderRadius: BorderRadius.circular(30),
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
            const SizedBox(height: 40),
            ..._options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textDark,
                  ),
                  onPressed: () => _checkAnswer(opt),
                  child: Text(opt, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
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
        title: const Text("Well Done!"),
        content: Text("You got $_score points!"),
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

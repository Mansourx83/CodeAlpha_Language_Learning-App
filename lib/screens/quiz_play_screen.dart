import 'package:flutter/material.dart';
import 'dart:math';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // جلب كل الكلمات للمستوى المختار
    final allWords = await DatabaseHelper.instance.getAllWords();
    final filtered = allWords.where((e) => e['level'] == widget.level).toList();

    if (filtered.length < 4) {
      setState(() => _isLoading = false);
      return;
    }

    filtered.shuffle();
    setState(() {
      _quizData = filtered.take(10).toList(); // اختبار من 10 أسئلة
      _isLoading = false;
    });
  }

  void _answer(String selected) {
    if (selected == _quizData[_currentIndex]['translation']) {
      _score++;
    }

    if (_currentIndex < _quizData.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Complete!"),
        content: Text("Your score is $_score out of ${_quizData.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_quizData.isEmpty)
      return const Scaffold(
        body: Center(child: Text("Not enough data for this level.")),
      );

    var currentQuestion = _quizData[_currentIndex];

    // توليد خيارات عشوائية
    List<String> options = [currentQuestion['translation']];
    var random = Random();
    while (options.length < 4) {
      var randomWord =
          _quizData[random.nextInt(_quizData.length)]['translation'];
      if (!options.contains(randomWord)) options.add(randomWord);
    }
    options.shuffle();

    return Scaffold(
      appBar: AppBar(title: Text("Quiz: ${widget.level}")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _quizData.length,
            ),
            const SizedBox(height: 40),
            const Text(
              "What is the meaning of:",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              currentQuestion['word'],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ...options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => _answer(opt),
                  child: Text(opt, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

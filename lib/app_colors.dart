import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية للخلفية والنصوص
  static const Color background = Color(0xFFF0F2F5);
  static const Color textDark = Color(0xFF1A1C1E);
  static const Color white = Colors.white;

  // ألوان مفردة (Primary Colors) للاستخدام في الأيقونات والأزرار البسيطة
  static const Color vocab = Color(0xFF66A6FF);
  static const Color grammar = Color(0xFFFDA085);
  static const Color phrases = Color(0xFF43E97B);
  static const Color quiz = Color(0xFFFA709A);
  
  // التدرجات اللونية (Gradients) للكروت الكبيرة
  static const List<Color> vocabGradient = [Color(0xFF66A6FF), Color(0xFF89F7FE)];
  static const List<Color> grammarGradient = [Color(0xFFFDA085), Color(0xFFF6D365)];
  static const List<Color> phrasesGradient = [Color(0xFF43E97B), Color(0xFF38F9D7)];
  static const List<Color> quizGradient = [Color(0xFFFA709A), Color(0xFFFEE140)];

  // دالة مساعدة للحصول على لون شفاف من أي لون
  static Color lighten(Color color, [double opacity = 0.15]) {
    return color.withOpacity(opacity);
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('learning_pro.db'); // اسم جديد لضمان تحديث الجداول
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        translation TEXT NOT NULL,
        category TEXT NOT NULL,
        level TEXT NOT NULL
      )
    ''');
    
    // إدخال البيانات الضخمة
    await _seedAllData(db);
  }

  Future<void> _seedAllData(Database db) async {
    final batch = db.batch(); // استخدام Batch لجعل الإدخال سريعاً جداً

    // عينة من كلمات A1 (أساسيات)
    _addItems(batch, 'A1', 'Vocabulary', {
      'Always': 'دائماً', 'Never': 'أبداً', 'Water': 'ماء', 'Food': 'طعام', 
      'House': 'منزل', 'Family': 'عائلة', 'Small': 'صغير', 'Large': 'كبير'
    });

    // عينة من كلمات A2 (حياة يومية)
    _addItems(batch, 'A2', 'Vocabulary', {
      'Experience': 'خبرة', 'Education': 'تعليم', 'Healthy': 'صحي', 'Weather': 'طقس',
      'Travel': 'سفر', 'Medicine': 'دواء', 'Market': 'سوق', 'Possible': 'ممكن'
    });

    // عينة من كلمات B1 (متوسط)
    _addItems(batch, 'B1', 'Vocabulary', {
      'Actually': 'في الحقيقة', 'Opportunity': 'فرصة', 'Improve': 'يتحسن', 'Necessary': 'ضروري',
      'Environment': 'البيئة', 'Decision': 'قرار', 'Success': 'نجاح', 'Global': 'عالمي'
    });

    // عينة من جمل (Phrases) للمستويات المختلفة
    _addItems(batch, 'A1', 'Phrases', {
      'How are you?': 'كيف حالك؟', 'Nice to meet you': 'سعدت بلقائك'
    });

    _addItems(batch, 'B2', 'Phrases', {
      'In the long run': 'على المدى البعيد', 'Bear in mind': 'ضع في اعتبارك'
    });

    await batch.commit(noResult: true);
  }

  // دالة مساعدة لتنظيم الإدخال
  void _addItems(Batch batch, String level, String category, Map<String, String> data) {
    data.forEach((word, trans) {
      batch.insert('vocabulary', {
        'word': word,
        'translation': trans,
        'category': category,
        'level': level,
      });
    });
  }

  // باقي الدوال البرمجية (insertWord, deleteWord, getWordsByCategoryAndLevel)
  Future<List<Map<String, dynamic>>> getWordsByCategoryAndLevel(String category, String level) async {
    final db = await instance.database;
    return await db.query(
      'vocabulary',
      where: 'category = ? AND level = ?',
      whereArgs: [category, level],
    );
  }

  Future<int> insertWord(String word, String translation, String category, {String level = "Custom"}) async {
    final db = await instance.database;
    return await db.insert('vocabulary', {
      'word': word,
      'translation': translation,
      'category': category,
      'level': level,
    });
  }

  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }
}
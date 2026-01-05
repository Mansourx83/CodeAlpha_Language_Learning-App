import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('lingo_master_v4.db'); // نسخة جديدة للداتا الضخمة
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
    await _seedAllData(db);
  }

  Future<void> _seedAllData(Database db) async {
    final batch = db.batch();

    // ================= LEVEL A1 =================
    _addItems(batch, 'A1', 'Vocabulary', {
      'Water': 'ماء',
      'Food': 'طعام',
      'Book': 'كتاب',
      'House': 'منزل',
      'Car': 'سيارة',
      'School': 'مدرسة',
      'Family': 'عائلة',
      'Friend': 'صديق',
      'Teacher': 'مدرس',
      'Student': 'طالب',
    });

    _addItems(batch, 'A1', 'Phrases', {
      'Hello': 'مرحباً',
      'Good morning': 'صباح الخير',
      'How are you?': 'كيف حالك؟',
      'Thank you': 'شكراً',
      'Nice to meet you': 'تشرفت بمعرفتك',
    });

    _addItems(batch, 'A1', 'Grammar', {
      'Verb to be (am/is/are)':
          'يُستخدم لوصف الحالة أو الاسم | Example: I am a student',
      'This / That': 'للإشارة للقريب والبعيد | Example: This is my book',
      'Plural nouns': 'جمع الاسم بإضافة s | Example: books',
    });

    // ================= LEVEL A2 =================
    _addItems(batch, 'A2', 'Vocabulary', {
      'Travel': 'سفر',
      'Weather': 'طقس',
      'Holiday': 'عطلة',
      'Job': 'وظيفة',
      'Money': 'مال',
      'Health': 'صحة',
      'Internet': 'إنترنت',
      'Restaurant': 'مطعم',
    });

    _addItems(batch, 'A2', 'Phrases', {
      'How much is this?': 'بكم هذا؟',
      'I need help': 'أحتاج مساعدة',
      'Can you repeat?': 'هل يمكنك الإعادة؟',
      'I don’t understand': 'لا أفهم',
    });

    _addItems(batch, 'A2', 'Grammar', {
      'Present Simple': 'يُستخدم للروتين والحقائق | Example: I work every day',
      'Past Simple': 'أحداث انتهت في الماضي | Example: I visited Cairo',
      'There is / There are': 'للتعبير عن وجود شيء | Example: There is a book',
    });

    // ================= LEVEL B1 =================
    _addItems(batch, 'B1', 'Vocabulary', {
      'Experience': 'خبرة',
      'Decision': 'قرار',
      'Improve': 'يحسن',
      'Opportunity': 'فرصة',
      'Responsibility': 'مسؤولية',
      'Success': 'نجاح',
    });

    _addItems(batch, 'B1', 'Phrases', {
      'In my opinion': 'في رأيي',
      'For example': 'على سبيل المثال',
      'As a result': 'كنتيجة لذلك',
      'I agree with you': 'أتفق معك',
    });

    _addItems(batch, 'B1', 'Grammar', {
      'Present Perfect':
          'لحدث بدأ في الماضي وله تأثير الآن | Example: I have finished',
      'Comparatives': 'للمقارنة بين شيئين | Example: bigger than',
      'First Conditional':
          'احتمال حقيقي في المستقبل | Example: If it rains, I will stay',
    });

    // ================= LEVEL B2 =================
    _addItems(batch, 'B2', 'Vocabulary', {
      'Achievement': 'إنجاز',
      'Environment': 'بيئة',
      'Impact': 'تأثير',
      'Strategy': 'استراتيجية',
      'Development': 'تطوير',
    });

    _addItems(batch, 'B2', 'Phrases', {
      'On the other hand': 'من ناحية أخرى',
      'In the long run': 'على المدى البعيد',
      'To sum up': 'خلاصة القول',
    });

    _addItems(batch, 'B2', 'Grammar', {
      'Passive Voice':
          'يُستخدم عندما يكون الفعل أهم من الفاعل | Example: The book was written',
      'Reported Speech': 'نقل الكلام | Example: He said he was tired',
      'Second Conditional':
          'احتمال غير واقعي | Example: If I were rich, I would travel',
    });

    // ================= LEVEL C1 =================
    _addItems(batch, 'C1', 'Vocabulary', {
      'Perspective': 'وجهة نظر',
      'Phenomenon': 'ظاهرة',
      'Significant': 'ملحوظ',
      'Consequently': 'وبالتالي',
      'Sustainable': 'مستدام',
      'Ethical': 'أخلاقي',
    });

    _addItems(batch, 'C1', 'Phrases', {
      'From my perspective': 'من وجهة نظري',
      'It is worth noting that': 'من الجدير بالذكر أن',
      'In contrast to': 'على النقيض من',
    });

    _addItems(batch, 'C1', 'Grammar', {
      'Advanced Conditionals':
          'جمل شرطية مركبة | Example: If I had known, I would have acted',
      'Inversion': 'عكس ترتيب الجملة للتأكيد | Example: Never have I seen this',
      'Participle Clauses':
          'اختصار الجمل | Example: Knowing the truth, he left',
    });

    // ================= LEVEL C2 =================
    _addItems(batch, 'C2', 'Vocabulary', {
      'Ambiguous': 'غامض',
      'Meticulous': 'دقيق جدًا',
      'Profound': 'عميق',
      'Paradigm': 'نموذج فكري',
      'Notion': 'مفهوم',
    });

    _addItems(batch, 'C2', 'Phrases', {
      'Be that as it may': 'مهما يكن',
      'In light of the fact that': 'في ضوء حقيقة أن',
      'It goes without saying': 'من البديهي',
    });

    _addItems(batch, 'C2', 'Grammar', {
      'Cleft Sentences':
          'تقسيم الجملة للتأكيد | Example: It was him who called',
      'Ellipsis':
          'حذف كلمات مفهومة | Example: I can play guitar, and she can too',
      'Subjunctive Mood':
          'صيغة افتراضية رسمية | Example: I suggest he be present',
    });

    await batch.commit(noResult: true);
  }

  void _addItems(
    Batch batch,
    String level,
    String category,
    Map<String, String> data,
  ) {
    data.forEach((word, trans) {
      batch.insert('vocabulary', {
        'word': word,
        'translation': trans,
        'category': category,
        'level': level,
      });
    });
  }

  Future<List<Map<String, dynamic>>> getWordsByCategoryAndLevel(
    String category,
    String level,
  ) async {
    final db = await instance.database;
    return await db.query(
      'vocabulary',
      where: 'category = ? AND level = ?',
      whereArgs: [category, level],
    );
  }

  Future<int> insertWord(
    String word,
    String translation,
    String category, {
    String level = "Custom",
  }) async {
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

  Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await instance.database;
    return await db.query('vocabulary');
  }
}

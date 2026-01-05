import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('learning.db');
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
        category TEXT NOT NULL
      )
    ''');
  }

  Future<int> deleteWord(int id) async {
    final db = await instance.database;
    return await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getWordsByCategory(String category) async {
    final db = await instance.database;
    return await db.query(
      'vocabulary',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // إضافة كلمة جديدة
  Future<int> insertWord(
    String word,
    String translation,
    String category,
  ) async {
    final db = await instance.database;
    return await db.insert('vocabulary', {
      'word': word,
      'translation': translation,
      'category': category,
    });
  }

  // جلب كل الكلمات
  Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await instance.database;
    return await db.query('vocabulary', orderBy: 'id DESC');
  }
}

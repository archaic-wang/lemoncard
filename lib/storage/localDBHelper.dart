import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static const dbName = 'students.db';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute('DROP TABLE IF EXISTS testTable');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS testAnswerTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              testId INTEGER,
              lessonId INTEGER,
              questionId INTEGER,
              datetime TIMESTAMP,
              answer_correctly INTEGER,
              FOREIGN KEY (lessonId) REFERENCES lessons (id),
              FOREIGN KEY (questionId) REFERENCES questions (question_id)
            )
          ''');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        age INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        studentId INTEGER,
        FOREIGN KEY (studentId) REFERENCES students (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY,
        lesson_id INTEGER,
        question TEXT,
        answer TEXT,
        n_correct INTEGER DEFAULT 0,
        n_wrong INTEGER DEFAULT 0,
        FOREIGN KEY (lesson_id) REFERENCES lessons (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS testAnswerTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        testId INTEGER,
        lessonId INTEGER,
        questionId INTEGER,
        datetime TIMESTAMP,
        answer_correctly INTEGER,
        FOREIGN KEY (lessonId) REFERENCES lessons (id),
        FOREIGN KEY (questionId) REFERENCES questions (question_id)
      )
    ''');
  }
}

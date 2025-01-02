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
      version: 5,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {

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
        id INTEGER PRIMARY KEY,
        lessonId INTEGER,
        question TEXT,
        answer TEXT,
        nCorrect INTEGER DEFAULT 0,
        nWrong INTEGER DEFAULT 0,
        FOREIGN KEY (lessonId) REFERENCES lessons (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS testAnswer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        testId INTEGER,
        lessonId INTEGER,
        questionId INTEGER,
        datetime TIMESTAMP,
        answerCorrectly INTEGER,
        FOREIGN KEY (lessonId) REFERENCES lessons (id),
        FOREIGN KEY (questionId) REFERENCES questions (id)
      )
    ''');
  }
}

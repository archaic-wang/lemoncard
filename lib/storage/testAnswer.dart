import 'package:sqflite/sqflite.dart';
import '../models/testAnswer.dart';
import 'localDBHelper.dart';

class TestAnswerTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTestAnswer(TestAnswer testAnswer) async {
    Database db = await _dbHelper.database;
    return await db.insert('testAnswer', testAnswer.toMap());
  }

  Future<List<TestAnswer>> getTestAnswersByQuestionId(int questionId) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'testAnswer',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'datetime DESC',
    );
    return List.generate(maps.length, (i) {
      return TestAnswer.fromMap(maps[i]);
    });
  }

  Future<List<int>> getIncorrectQuestionIds() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT questionId 
      FROM testAnswer 
      WHERE questionId IN (
        SELECT questionId 
        FROM testAnswer 
        GROUP BY questionId 
        HAVING MAX(datetime) = (
          SELECT MAX(datetime) 
          FROM testAnswer t2 
          WHERE t2.questionId = testAnswer.questionId
        ) 
        AND answerCorrectly = 0
      )
    ''');
    return maps.map((map) => map['questionId'] as int).toList();
  }

  Future<TestAnswer?> getLatestTestAnswerForQuestion(int questionId) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'testAnswer',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'datetime DESC',
      limit: 1,
    );
    if (maps.isEmpty) {
      return null;
    }
    return TestAnswer.fromMap(maps.first);
  }
}

import '../models/testAnswer.dart';
import 'localDBHelper.dart';

class TestAnswerTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTestAnswer(TestAnswer answer) async {
    final db = await _dbHelper.database;
    return db.insert('testAnswerTable', answer.toMap());
  }

  Future<List<TestAnswer>> getAllTestAnswers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('testAnswerTable');
    return maps.map((m) => TestAnswer.fromMap(m)).toList();
  }

  Future<int> updateTestAnswer(TestAnswer answer) async {
    final db = await _dbHelper.database;
    return db.update(
      'testAnswerTable',
      answer.toMap(),
      where: 'id = ?',
      whereArgs: [answer.id],
    );
  }

  Future<int> deleteTestAnswer(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'testAnswerTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

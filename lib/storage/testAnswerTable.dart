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

  Future<TestAnswer?> getLatestAnswer(int questionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'testAnswerTable',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'datetime DESC',
      limit: 1
    );
    if (maps.isNotEmpty) {
      return TestAnswer.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<int>> getLastTimeWrongQuestionIds() async {
    final db = await _dbHelper.database;
    
    // 1. Find the most recent testId
    final List<Map<String, dynamic>> latestTest = await db.query(
      'testAnswerTable',
      columns: ['testId'],
      orderBy: 'datetime DESC',
      limit: 1
    );

    if (latestTest.isEmpty) {
      return [];
    }

    final int latestTestId = latestTest.first['testId'] as int;

    // 2. Query testAnswers with that testId where answerCorrectly = false
    final List<Map<String, dynamic>> wrongAnswers = await db.query(
      'testAnswerTable',
      columns: ['questionId'],
      where: 'testId = ? AND answerCorrectly = ?',
      whereArgs: [latestTestId, 0],
      distinct: true
    );

    // 3. Return a list of questionIds
    return wrongAnswers.map((m) => m['questionId'] as int).toList();
  }
}

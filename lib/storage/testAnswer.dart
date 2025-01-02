import '../models/testAnswer.dart';
import 'localDBHelper.dart';

class TestAnswerTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertTestAnswer(TestAnswer answer) async {
    final db = await _dbHelper.database;
    await db.insert('testAnswer', {
      'testId': answer.testId,
      'lessonId': answer.lessonId,
      'questionId': answer.questionId,
      'datetime': DateTime.now().toIso8601String(),
      'answerCorrectly': answer.answerCorrectly ? 1 : 0,
    });
  }

  Future<List<TestAnswer>> getAllTestAnswers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('testAnswer');
    return maps.map((m) => TestAnswer.fromMap(m)).toList();
  }

  Future<int> updateTestAnswer(TestAnswer answer) async {
    final db = await _dbHelper.database;
    return db.update(
      'testAnswer',
      {
        'testId': answer.testId,
        'lessonId': answer.lessonId,
        'questionId': answer.questionId,
        'datetime': answer.datetime.toIso8601String(),
        'answerCorrectly': answer.answerCorrectly ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [answer.id],
    );
  }

  Future<int> deleteTestAnswer(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'testAnswer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<TestAnswer?> getLatestAnswer(int questionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'testAnswer',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'datetime DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return TestAnswer.fromMap(result.first);
    }
    return null;
  }

  Future<List<int>> getLastTimeWrongQuestionIds() async {
    final db = await _dbHelper.database;
    
    // 1. Find the most recent testId
    final List<Map<String, dynamic>> latestTest = await db.query(
      'testAnswer',
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
      'testAnswer',
      columns: ['questionId'],
      where: 'testId = ? AND answerCorrectly = ?',
      whereArgs: [latestTestId, 0],
    );
    
    return wrongAnswers.map((m) => m['questionId'] as int).toList();
  }
}

import 'localDBHelper.dart';

class TestTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTestRecord({
    required int testId,
    required int lessonId,
    required int questionId,
    required bool answerCorrectly,
    required DateTime dateTime,
  }) async {
    final db = await _dbHelper.database;
    return db.insert('testTable', {
      'testId': testId,
      'lessonId': lessonId,
      'questionId': questionId,
      'datetime': dateTime.toIso8601String(),
      'answer_correctly': answerCorrectly ? 1 : 0,
    });
  }
}

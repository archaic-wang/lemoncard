import 'package:sqflite/sqflite.dart';
import '../models/testAnswer.dart';
import './localDBHelper.dart';
import '../constants/config.dart';

class TestAnswerTable {
  final _dbHelper = DatabaseHelper();

  Future<List<int>> getLastTimeWrongQuestionIds(int lessonId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT questionId 
      FROM testAnswer 
      WHERE lessonId = ? 
      AND questionId IN (
        SELECT questionId 
        FROM testAnswer 
        WHERE lessonId = ? 
        GROUP BY questionId 
        HAVING MAX(datetime) = (
          SELECT MAX(datetime) 
          FROM testAnswer t2 
          WHERE t2.questionId = testAnswer.questionId
        ) 
        AND answerCorrectly = 0
      )
    ''', [lessonId, lessonId]);

    return maps.map((map) => map['questionId'] as int).toList();
  }

  Future<TestAnswer?> getLatestAnswer(int questionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'testAnswer',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'datetime DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return TestAnswer(
      testId: maps[0]['testId'] as int,
      lessonId: maps[0]['lessonId'] as int,
      questionId: maps[0]['questionId'] as int,
      datetime: DateTime.parse(maps[0]['datetime'] as String),
      answerCorrectly: maps[0]['answerCorrectly'] == 1,
    );
  }

  Future<void> insertTestAnswer(TestAnswer testAnswer) async {
    final db = await _dbHelper.database;
    await db.insert(
      'testAnswer',
      {
        'testId': testAnswer.testId,
        'lessonId': testAnswer.lessonId,
        'questionId': testAnswer.questionId,
        'datetime': testAnswer.datetime.toIso8601String(),
        'answerCorrectly': testAnswer.answerCorrectly ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<int>> getPriorityQuestionIds(int lessonId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT q.id as questionId
      FROM questions q
      LEFT JOIN testAnswer ta ON q.id = ta.questionId
      WHERE q.lessonId = ?
        AND (
          ta.questionId IS NULL
          OR q.id IN (
            SELECT questionId 
            FROM testAnswer 
            WHERE lessonId = ?
            GROUP BY questionId 
            HAVING MAX(datetime) = (
              SELECT MAX(datetime) 
              FROM testAnswer t2 
              WHERE t2.questionId = testAnswer.questionId
            ) 
            AND answerCorrectly = 0
          )
        )
      ORDER BY RANDOM()
      LIMIT ?
    ''', [lessonId, lessonId, LemonCardConfig.TEST_QUESTION_COUNT]);

    return maps.map((map) => map['questionId'] as int).toList();
  }
}

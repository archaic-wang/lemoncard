import 'package:sqflite/sqflite.dart';
import '../models/question.dart';
import 'localDBHelper.dart';

class QuestionTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertQuestion(Question question) async {
    Database db = await _dbHelper.database;
    return await db.insert('questions', question.toMap());
  }

  Future<List<Question>> getQuestionsByLessonId(int lessonId) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<int> updateQuestion(Question question) async {
    Database db = await _dbHelper.database;
    return await db.update(
      'questions',
      question.toMap(),
      where: 'id = ?',
      whereArgs: [question.id],
    );
  }

  Future<int> deleteQuestion(int questionId) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      'questions',
      where: 'id = ?',
      whereArgs: [questionId],
    );
  }

  Future<List<Question>> getAllQuestions() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('questions');
    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<List<Question>> getQuestionsByIds(List<int> questionIds) async {
    if (questionIds.isEmpty) {
      return [];
    }
    Database db = await _dbHelper.database;
    final placeholders = List.filled(questionIds.length, '?').join(',');
    List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'id IN ($placeholders)',
      whereArgs: questionIds,
    );
    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  Future<void> resetCountersByLessonId(int lessonId) async {
    Database db = await _dbHelper.database;
    await db.update(
      'questions',
      {'nCorrect': 0, 'nWrong': 0},
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
  }
}

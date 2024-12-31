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
      where: 'lesson_id = ?',
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
      where: 'question_id = ?',
      whereArgs: [question.questionId],
    );
  }

  Future<int> deleteQuestion(int questionId) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      'questions',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }
}

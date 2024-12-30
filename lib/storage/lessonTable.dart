import 'package:sqflite/sqflite.dart';
import '../models/lesson.dart';
import 'localDBHelper.dart';

class LessonTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertLesson(Lesson lesson) async {
    Database db = await _dbHelper.database;
    return await db.insert('lessons', lesson.toMap());
  }

  Future<List<Lesson>> getLessonsForStudent(int studentId) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'lessons',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return List.generate(maps.length, (i) {
      return Lesson.fromMap(maps[i]);
    });
  }

  Future<int> updateLesson(Lesson lesson) async {
    Database db = await _dbHelper.database;
    return await db.update(
      'lessons',
      lesson.toMap(),
      where: 'id = ?',
      whereArgs: [lesson.id],
    );
  }

  Future<int> deleteLesson(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      'lessons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
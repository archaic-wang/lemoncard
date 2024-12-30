import 'package:sqflite/sqflite.dart';
import '../models/student.dart';
import 'localDBHelper.dart';

class StudentTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertStudent(Student student) async {
    Database db = await _dbHelper.database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getStudents() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) {
      return Student(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<int> updateStudent(Student student) async {
    Database db = await _dbHelper.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
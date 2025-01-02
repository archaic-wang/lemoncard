import '../models/testRecord.dart';
import 'localDBHelper.dart';

class TestTable {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertTestRecord(TestRecord record) async {
    final db = await _dbHelper.database;
    return db.insert('testTable', record.toMap());
  }

  Future<List<TestRecord>> getAllTestRecords() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('testTable');
    return maps.map((m) => TestRecord.fromMap(m)).toList();
  }

  Future<int> updateTestRecord(TestRecord record) async {
    final db = await _dbHelper.database;
    return db.update(
      'testTable',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteTestRecord(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'testTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/testRecord.dart';
import '../storage/questionTable.dart';
import '../storage/testTable.dart';

class TestLemonCard extends StatefulWidget {
  final Question question;
  final QuestionTable questionTable;
  final int testId;
  final VoidCallback? onHide;

  const TestLemonCard({
    super.key,
    required this.question,
    required this.questionTable,
    required this.testId,
    this.onHide,
  });

  @override
  State<TestLemonCard> createState() => _TestLemonCardState();
}

class _TestLemonCardState extends State<TestLemonCard> {
  Future<void> _markCorrect() async {
    final testTable = TestTable();
    await testTable.insertTestRecord(
      TestRecord(
        id: 0, // SQLite will auto-increment this
        testId: widget.testId,
        lessonId: widget.question.lessonId,
        questionId: widget.question.questionId,
        answerCorrectly: true,
        datetime: DateTime.now(),
      ),
    );
    widget.onHide?.call();
  }

  Future<void> _markWrong() async {
    final testTable = TestTable();
    await testTable.insertTestRecord(
      TestRecord(
        id: 0, // SQLite will auto-increment this
        testId: widget.testId,
        lessonId: widget.question.lessonId,
        questionId: widget.question.questionId,
        answerCorrectly: false,
        datetime: DateTime.now(),
      ),
    );
    widget.onHide?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 48.0,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  color: Colors.green,
                  onPressed: _markCorrect,
                  tooltip: 'Mark as correct',
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  color: Colors.red,
                  onPressed: _markWrong,
                  tooltip: 'Mark as wrong',
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

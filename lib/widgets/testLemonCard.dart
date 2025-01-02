import 'package:flutter/material.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';

class TestLemonCard extends StatefulWidget {
  final Question question;
  final QuestionTable questionTable;

  const TestLemonCard({
    super.key,
    required this.question,
    required this.questionTable,
  });

  @override
  State<TestLemonCard> createState() => _TestLemonCardState();
}

class _TestLemonCardState extends State<TestLemonCard> {
  Future<void> _markCorrect() async {
    await widget.questionTable.updateQuestion(
      Question(
        questionId: widget.question.questionId,
        lessonId: widget.question.lessonId,
        question: widget.question.question,
        answer: widget.question.answer,
        nCorrect: widget.question.nCorrect + 1,
        nWrong: widget.question.nWrong,
      ),
    );
  }

  Future<void> _markWrong() async {
    await widget.questionTable.updateQuestion(
      Question(
        questionId: widget.question.questionId,
        lessonId: widget.question.lessonId,
        question: widget.question.question,
        answer: widget.question.answer,
        nCorrect: widget.question.nCorrect,
        nWrong: widget.question.nWrong + 1,
      ),
    );
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
              child: Text(
                widget.question.answer,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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

import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/testAnswer.dart';
import '../storage/questionTable.dart';
import '../storage/testAnswerTable.dart';

class TestLemonCard extends StatefulWidget {
  final Question question;
  final QuestionTable questionTable;
  final int testId;
  const TestLemonCard({
    super.key,
    required this.question,
    required this.questionTable,
    required this.testId,
  });

  @override
  State<TestLemonCard> createState() => _TestLemonCardState();
}

class _TestLemonCardState extends State<TestLemonCard> {
  bool _showNotAnswer = true;  // Show [not answer] initially

  Future<void> _markCorrect() async {
    final testAnswerTable = TestAnswerTable();
    await testAnswerTable.insertTestAnswer(
      TestAnswer(
        testId: widget.testId,
        lessonId: widget.question.lessonId,
        questionId: widget.question.questionId,
        answerCorrectly: true,
        datetime: DateTime.now(),
      ),
    );
    final updatedQuestion = Question(
      questionId: widget.question.questionId,
      lessonId: widget.question.lessonId,
      question: widget.question.question,
      answer: widget.question.answer,
      nCorrect: widget.question.nCorrect + 1,
      nWrong: widget.question.nWrong,
    );
    await widget.questionTable.updateQuestion(updatedQuestion);
    setState(() {
      _showNotAnswer = false;
    });
  }

  Future<void> _markWrong() async {
    final testAnswerTable = TestAnswerTable();
    await testAnswerTable.insertTestAnswer(
      TestAnswer(
        testId: widget.testId,
        lessonId: widget.question.lessonId,
        questionId: widget.question.questionId,
        answerCorrectly: false,
        datetime: DateTime.now(),
      ),
    );
    final updatedQuestion = Question(
      questionId: widget.question.questionId,
      lessonId: widget.question.lessonId,
      question: widget.question.question,
      answer: widget.question.answer,
      nCorrect: widget.question.nCorrect,
      nWrong: widget.question.nWrong + 1,
    );
    await widget.questionTable.updateQuestion(updatedQuestion);
    setState(() {
      _showNotAnswer = false;
    });
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
              alignment: Alignment.bottomLeft,
              child: _showNotAnswer
                  ? const Text(
                      'not answer',
                      style: TextStyle(fontSize: 16.0),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stats display
                Row(
                  children: [
                    Text(
                      'Correct: ${widget.question.nCorrect}',
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Wrong: ${widget.question.nWrong}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                // Action buttons
                Row(
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
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';

class TestLemonCard extends StatelessWidget {
  final Question question;
  final QuestionTable questionTable;
  final int testId;
  final Function(Question) onMarkCorrect;
  final Function(Question) onMarkWrong;
  final bool isAnswered;

  const TestLemonCard({
    super.key,
    required this.question,
    required this.questionTable,
    required this.testId,
    required this.onMarkCorrect,
    required this.onMarkWrong,
    required this.isAnswered,
  });

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
              question.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 48.0,
              alignment: Alignment.bottomLeft,
              child: !isAnswered
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
                      'Correct: ${question.nCorrect}',
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Wrong: ${question.nWrong}',
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
                      onPressed: isAnswered ? null : () => onMarkCorrect(question),
                      tooltip: 'Mark as correct',
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      color: Colors.red,
                      onPressed: isAnswered ? null : () => onMarkWrong(question),
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

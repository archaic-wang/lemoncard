import 'package:flutter/material.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import 'testLemonCard.dart';

class TestLemonCardList extends StatelessWidget {
  final List<Question> questions;
  final QuestionTable questionTable;
  final int testId;
  final Function(Question) onMarkCorrect;
  final Function(Question) onMarkWrong;
  final Map<int, bool> answeredMap;

  const TestLemonCardList({
    super.key,
    required this.questions,
    required this.questionTable,
    required this.testId,
    required this.onMarkCorrect,
    required this.onMarkWrong,
    required this.answeredMap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final question = questions[index];
        return TestLemonCard(
          question: question,
          questionTable: questionTable,
          testId: testId,
          onMarkCorrect: (q) => onMarkCorrect(q),
          onMarkWrong: (q) => onMarkWrong(q),
          isAnswered: answeredMap[question.id] ?? false,
        );
      },
    );
  }
}

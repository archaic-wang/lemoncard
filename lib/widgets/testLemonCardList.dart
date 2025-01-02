import 'package:flutter/material.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import 'testLemonCard.dart';

class TestLemonCardList extends StatelessWidget {
  final List<Question> questions;
  final QuestionTable questionTable;

  const TestLemonCardList({
    super.key,
    required this.questions,
    required this.questionTable,
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
        );
      },
    );
  }
}

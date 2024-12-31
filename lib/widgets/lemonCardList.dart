import 'package:flutter/material.dart';
import '../models/question.dart';
import 'lemonCard.dart';

class LemonCardList extends StatelessWidget {
  final List<Question> questions;
  final Function(Question) onItemTap;

  const LemonCardList({
    super.key, 
    required this.questions, 
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final question = questions[index];
        return LemonCard(
          question: question,
          onTap: () => onItemTap(question),
        );
      },
    );
  }
}

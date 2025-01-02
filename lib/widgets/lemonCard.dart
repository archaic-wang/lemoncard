import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/testAnswer.dart';
import '../utils/datetime.dart';

class LemonCard extends StatelessWidget {
  final Question question;
  final VoidCallback onTap;
  final TestAnswer? latestAnswer;
  
  const LemonCard({
    super.key, 
    required this.question,
    required this.onTap,
    required this.latestAnswer,
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
                child: Text(
                  question.answer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text('${question.nCorrect} correct'),
                          const SizedBox(width: 16.0),
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text('${question.nWrong} wrong'),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onTap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  if (latestAnswer != null) ...[
                    Text(
                      'Last test: ${formatDateTime(latestAnswer!.datetime)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      latestAnswer!.answerCorrectly ? 'Correct' : 'Wrong',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ] else
                    Text(
                      'not answered yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

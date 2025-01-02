import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/testAnswer.dart';
import '../storage/testAnswerTable.dart';

class LemonCard extends StatefulWidget {
  final Question question;
  final VoidCallback onTap;
  
  const LemonCard({
    super.key, 
    required this.question, 
    required this.onTap,
  });

  @override
  State<LemonCard> createState() => _LemonCardState();
}

class _LemonCardState extends State<LemonCard> {
  TestAnswer? _latestAnswer;

  @override
  void initState() {
    super.initState();
    _loadLatestAnswer();
  }

  void _loadLatestAnswer() async {
    final testAnswerTable = TestAnswerTable();
    final result = await testAnswerTable.getLatestAnswer(widget.question.questionId);
    setState(() {
      _latestAnswer = result;
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
                child: Text(
                  widget.question.answer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 8.0),
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
                      Text('${widget.question.nCorrect} correct'),
                      const SizedBox(width: 16.0),
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text('${widget.question.nWrong} wrong'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_latestAnswer != null) ...[
                        Text(
                          'Last test: ${_latestAnswer!.datetime.toLocal()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _latestAnswer!.answerCorrectly ? 'Correct' : 'Wrong',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: widget.onTap,
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

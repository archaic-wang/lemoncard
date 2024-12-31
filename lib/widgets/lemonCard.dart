import 'package:flutter/material.dart';
import '../models/question.dart';

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
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onTap,
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
              if (_showAnswer) ...[
                Text(
                  widget.question.answer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8.0),
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
              ],
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(_showAnswer ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showAnswer = !_showAnswer;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';

class LemonCardDetailPage extends StatefulWidget {
  final Lesson lesson;
  final Question? question;

  const LemonCardDetailPage({super.key, required this.lesson, this.question});

  @override
  State<LemonCardDetailPage> createState() => _LemonCardDetailPageState();
}

class _LemonCardDetailPageState extends State<LemonCardDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  int _nCorrect = 0;
  int _nWrong = 0;

  final QuestionTable _questionTable = QuestionTable();

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      _answerController.text = widget.question!.answer;
      _nCorrect = widget.question!.nCorrect;
      _nWrong = widget.question!.nWrong;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      final newQuestion = Question(
        id: widget.question?.id ?? DateTime.now().millisecondsSinceEpoch,
        lessonId: widget.lesson.id,
        question: _questionController.text,
        answer: _answerController.text,
        nCorrect: _nCorrect,
        nWrong: _nWrong,
      );

      if (widget.question == null) {
        await _questionTable.insertQuestion(newQuestion);
      } else {
        await _questionTable.updateQuestion(newQuestion);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _deleteQuestion() async {
    if (widget.question != null) {
      await _questionTable.deleteQuestion(widget.question!.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'New Lemon Card' : 'Edit Lemon Card'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty) 
                  ? 'Please enter a question' 
                  : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: null,
              ),

              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveQuestion,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Save'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Cancel'),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.question != null) ...[
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _deleteQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Delete'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

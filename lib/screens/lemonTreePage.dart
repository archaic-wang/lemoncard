import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import '../widgets/lemonCardList.dart';
import 'lemonCardDetailPage.dart';

class LemonTreePage extends StatefulWidget {
  final Lesson lesson;

  const LemonTreePage({super.key, required this.lesson});

  @override
  State<LemonTreePage> createState() => _LemonTreePageState();
}

class _LemonTreePageState extends State<LemonTreePage> {
  final QuestionTable _questionTable = QuestionTable();
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final data = await _questionTable.getQuestionsByLessonId(widget.lesson.id);
    setState(() {
      questions = data;
    });
  }

  Future<void> _navigateToQuestionDetail({Question? question}) async {
    // Note: LemonCardDetailPage will be created in the next step
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LemonCardDetailPage(
          lesson: widget.lesson, 
          question: question,
        ),
      ),
    );
    if (result == true) {
      _loadQuestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lemon Tree: ${widget.lesson.name}'),
        elevation: 2,
      ),
      body: LemonCardList(
        questions: questions,
        onItemTap: (q) => _navigateToQuestionDetail(question: q),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToQuestionDetail(),
        child: const Icon(Icons.add),
        tooltip: 'Add new question',
      ),
    );
  }
}

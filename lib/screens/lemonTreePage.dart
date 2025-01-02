import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import '../widgets/lemonCardList.dart';
import 'lemonCardDetailPage.dart';
import 'testLemonTreePage.dart';

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _navigateToQuestionDetail(),
              child: const Icon(Icons.add),
              tooltip: 'Add new question',
              heroTag: 'add_question',
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TestLemonTreePage(),
                  ),
                );
              },
              child: const Icon(Icons.play_arrow),
              tooltip: 'Test questions',
              heroTag: 'test_questions',
            ),
          ],
        ),
      ),
    );
  }
}

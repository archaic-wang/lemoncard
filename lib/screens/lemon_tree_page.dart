import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import '../models/testAnswer.dart';
import '../storage/questionTable.dart';
import '../storage/testAnswerTable.dart';
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
  Map<int, TestAnswer?> latestAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((_) {
      _loadLatestAnswers().then((map) {
        setState(() {
          latestAnswers = map;
        });
      });
    });
  }

  Future<void> _loadQuestions() async {
    final data = await _questionTable.getQuestionsByLessonId(widget.lesson.id);
    setState(() {
      questions = data;
    });
  }

  Future<Map<int, TestAnswer?>> _loadLatestAnswers() async {
    final testAnswerTable = TestAnswerTable();
    final Map<int, TestAnswer?> resultMap = {};
    for (final q in questions) {
      final latest = await testAnswerTable.getLatestAnswer(q.id);
      resultMap[q.id] = latest;
    }
    return resultMap;
  }

  Future<void> _resetAnswers() async {
    await TestAnswerTable().deleteAnswersByLessonId(widget.lesson.id);
    await QuestionTable().resetCountersByLessonId(widget.lesson.id);
    await _loadQuestions();
    final map = await _loadLatestAnswers();
    setState(() {
      latestAnswers = map;
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
        fullscreenDialog: true,
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
        latestAnswers: latestAnswers,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _navigateToQuestionDetail(),
              tooltip: 'Add new question',
              heroTag: 'add_question',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: _resetAnswers,
              tooltip: 'Reset answers',
              heroTag: 'reset_answers',
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestLemonTreePage(
                      lessonId: widget.lesson.id,
                    ),
                    fullscreenDialog: true,
                  ),
                ).then((_) async {
                  // after pop, refresh questions and latest answers
                  await _loadQuestions();
                  final map = await _loadLatestAnswers();
                  setState(() {
                    latestAnswers = map;
                  });
                });
              },
              tooltip: 'Test questions',
              heroTag: 'test_questions',
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Lemon Tree: ${widget.lesson.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              LemonCardList(
                questions: questions,
                onItemTap: (q) => _navigateToQuestionDetail(question: q),
                latestAnswers: latestAnswers,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
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
                      onPressed: _resetAnswers,
                      child: const Icon(Icons.refresh),
                      tooltip: 'Reset answers',
                      heroTag: 'reset_answers',
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
                      child: const Icon(Icons.play_arrow),
                      tooltip: 'Test questions',
                      heroTag: 'test_questions',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

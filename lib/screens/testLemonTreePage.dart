import 'package:flutter/material.dart';
import '../constants/config.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import '../storage/testAnswer.dart';
import '../widgets/testLemonCardList.dart';

class TestLemonTreePage extends StatefulWidget {
  final int lessonId;
  const TestLemonTreePage({super.key, required this.lessonId});

  @override
  State<TestLemonTreePage> createState() => _TestLemonTreePageState();
}

class _TestLemonTreePageState extends State<TestLemonTreePage> {
  final QuestionTable _questionTable = QuestionTable();
  List<Question> _testQuestions = [];
  bool _isLoading = true;
  int _testId = 0;

  @override
  void initState() {
    super.initState();
    _testId = DateTime.now().millisecondsSinceEpoch;
    _loadQuestions();
  }

  Future<void> _loadRandomQuestions() async {
    List<Question> allQuestions = await _questionTable.getQuestionsByLessonId(widget.lessonId);
    allQuestions.shuffle();
    setState(() {
      _testQuestions = allQuestions.take(LemonCardConfig.TEST_QUESTION_COUNT).toList();
      _isLoading = false;
    });
  }

  Future<bool> _showRandomQuestionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('All Questions Answered Correctly'),
          content: const Text('The student has answered the questions correctly. Do you want to start a test with random questions?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _loadQuestions() async {
    final testAnswerTable = TestAnswerTable();
    final wrongQuestionIds = await testAnswerTable.getIncorrectQuestionIds();
    
    if (wrongQuestionIds.isEmpty) {
      final shouldLoadRandom = await _showRandomQuestionDialog();
      if (shouldLoadRandom) {
        await _loadRandomQuestions();
      } else {
        Navigator.pop(context);
      }
    } else {
      final questions = await _questionTable.getQuestionsByIds(wrongQuestionIds);
      questions.shuffle(); // Randomize order of wrong questions
      setState(() {
        _testQuestions = questions.take(LemonCardConfig.TEST_QUESTION_COUNT).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Lemon Tree'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: TestLemonCardList(
                    questions: _testQuestions,
                    questionTable: _questionTable,
                    testId: _testId,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
    );
  }
}

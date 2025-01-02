import 'package:flutter/material.dart';
import '../constants/config.dart';
import '../models/question.dart';
import '../models/testAnswer.dart';
import '../storage/questionTable.dart';
import '../storage/testAnswerTable.dart';
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
  final Map<int, String> _answerSelectionMap = {}; // Values: "correct", "wrong", "none"

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

  Future<void> _markCorrect(Question question) async {
    final oldState = _answerSelectionMap[question.id] ?? "none";
    final testAnswerTable = TestAnswerTable();
    final testAnswer = TestAnswer(
      testId: _testId,
      lessonId: question.lessonId,
      questionId: question.id,
      answerCorrectly: true,
      datetime: DateTime.now(),
    );
    await testAnswerTable.insertTestAnswer(testAnswer);

    int newNCorrect = question.nCorrect;
    int newNWrong = question.nWrong;

    if (oldState == "wrong") {
      newNCorrect += 1;
      newNWrong -= 1;
    } else if (oldState == "none") {
      newNCorrect += 1;
    }
    // If oldState was "correct", do nothing with counters

    final updatedQuestion = Question(
      id: question.id,
      lessonId: question.lessonId,
      question: question.question,
      answer: question.answer,
      nCorrect: newNCorrect,
      nWrong: newNWrong,
    );
    await _questionTable.updateQuestion(updatedQuestion);
    setState(() {
      // Update local question list with increments
      final idx = _testQuestions.indexWhere((q) => q.id == question.id);
      if (idx != -1) {
        _testQuestions[idx] = updatedQuestion;
      }
      _answerSelectionMap[question.id] = "correct";
    });
  }

  Future<void> _markWrong(Question question) async {
    final oldState = _answerSelectionMap[question.id] ?? "none";
    final testAnswerTable = TestAnswerTable();
    final testAnswer = TestAnswer(
      testId: _testId,
      lessonId: question.lessonId,
      questionId: question.id,
      answerCorrectly: false,
      datetime: DateTime.now(),
    );
    await testAnswerTable.insertTestAnswer(testAnswer);

    int newNCorrect = question.nCorrect;
    int newNWrong = question.nWrong;

    if (oldState == "correct") {
      newNCorrect -= 1;
      newNWrong += 1;
    } else if (oldState == "none") {
      newNWrong += 1;
    }
    // If oldState was "wrong", do nothing with counters

    final updatedQuestion = Question(
      id: question.id,
      lessonId: question.lessonId,
      question: question.question,
      answer: question.answer,
      nCorrect: newNCorrect,
      nWrong: newNWrong,
    );
    await _questionTable.updateQuestion(updatedQuestion);
    setState(() {
      // Update local question list with increments
      final idx = _testQuestions.indexWhere((q) => q.id == question.id);
      if (idx != -1) {
        _testQuestions[idx] = updatedQuestion;
      }
      _answerSelectionMap[question.id] = "wrong";
    });
  }

  Future<void> _loadQuestions() async {
    final testAnswerTable = TestAnswerTable();
    final priorityQuestionIds = await testAnswerTable.getPriorityQuestionIds(widget.lessonId);
    
    if (priorityQuestionIds.isEmpty) {
      final shouldLoadRandom = await _showRandomQuestionDialog();
      if (shouldLoadRandom) {
        await _loadRandomQuestions();
      } else {
        Navigator.pop(context);
      }
    } else {
      final questions = await _questionTable.getQuestionsByIds(priorityQuestionIds);
      setState(() {
        _testQuestions = questions;  // No need to shuffle or take, already done in getPriorityQuestionIds
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
                    onMarkCorrect: _markCorrect,
                    onMarkWrong: _markWrong,
                    answerSelectionMap: _answerSelectionMap,
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

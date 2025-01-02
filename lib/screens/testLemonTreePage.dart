import 'package:flutter/material.dart';
import '../constants/config.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import '../widgets/testLemonCardList.dart';

class TestLemonTreePage extends StatefulWidget {
  const TestLemonTreePage({super.key});

  @override
  State<TestLemonTreePage> createState() => _TestLemonTreePageState();
}

class _TestLemonTreePageState extends State<TestLemonTreePage> {
  final QuestionTable _questionTable = QuestionTable();
  List<Question> _testQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    List<Question> allQuestions = await _questionTable.getAllQuestions();
    allQuestions.shuffle();
    setState(() {
      _testQuestions = allQuestions.take(LemonCardConfig.TEST_QUESTION_COUNT).toList();
      _isLoading = false;
    });
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

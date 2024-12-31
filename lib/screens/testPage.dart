import 'package:flutter/material.dart';
import '../constants/config.dart';
import '../models/question.dart';
import '../storage/questionTable.dart';
import '../widgets/testLemonCard.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
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
        title: const Text('Test Questions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _testQuestions.length,
                    itemBuilder: (context, index) {
                      return TestLemonCard(
                        question: _testQuestions[index],
                        questionTable: _questionTable,
                      );
                    },
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

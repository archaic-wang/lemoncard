class TestRecord {
  final int id;
  final int testId;
  final int lessonId;
  final int questionId;
  final DateTime datetime;
  final bool answerCorrectly;

  TestRecord({
    required this.id,
    required this.testId,
    required this.lessonId,
    required this.questionId,
    required this.datetime,
    required this.answerCorrectly,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'testId': testId,
      'lessonId': lessonId,
      'questionId': questionId,
      'datetime': datetime.toIso8601String(),
      'answer_correctly': answerCorrectly ? 1 : 0,
    };
  }

  factory TestRecord.fromMap(Map<String, dynamic> map) {
    return TestRecord(
      id: map['id'],
      testId: map['testId'],
      lessonId: map['lessonId'],
      questionId: map['questionId'],
      datetime: DateTime.parse(map['datetime']),
      answerCorrectly: map['answer_correctly'] == 1,
    );
  }
}

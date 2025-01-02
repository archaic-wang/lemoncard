class TestAnswer {
  final int? id;
  final int testId;
  final int lessonId;
  final int questionId;
  final DateTime datetime;
  final bool answerCorrectly;

  TestAnswer({
    this.id,
    required this.testId,
    required this.lessonId,
    required this.questionId,
    required this.datetime,
    required this.answerCorrectly,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'testId': testId,
      'lessonId': lessonId,
      'questionId': questionId,
      'datetime': datetime.toIso8601String(),
      'answerCorrectly': answerCorrectly ? 1 : 0,
    };
  }

  factory TestAnswer.fromMap(Map<String, dynamic> map) {
    return TestAnswer(
      id: map['id'] as int?, // Read id as nullable int
      testId: map['testId'] as int,
      lessonId: map['lessonId'] as int,
      questionId: map['questionId'] as int,
      datetime: DateTime.parse(map['datetime'] as String),
      answerCorrectly: map['answerCorrectly'] == 1,
    );
  }
}

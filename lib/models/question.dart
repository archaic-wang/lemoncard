class Question {
  final int id;
  final int lessonId;
  final String question;
  final String answer;
  final int nCorrect;
  final int nWrong;

  Question({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.answer,
    required this.nCorrect,
    required this.nWrong,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'question': question,
      'answer': answer,
      'nCorrect': nCorrect,
      'nWrong': nWrong,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      lessonId: map['lessonId'],
      question: map['question'],
      answer: map['answer'],
      nCorrect: map['nCorrect'] ?? 0,
      nWrong: map['nWrong'] ?? 0,
    );
  }
}

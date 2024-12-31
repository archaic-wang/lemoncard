class Question {
  final int questionId;
  final int lessonId;
  final String question;
  final String answer;
  final int nCorrect;
  final int nWrong;

  Question({
    required this.questionId,
    required this.lessonId,
    required this.question,
    required this.answer,
    required this.nCorrect,
    required this.nWrong,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'lesson_id': lessonId,
      'question': question,
      'answer': answer,
      'n_correct': nCorrect,
      'n_wrong': nWrong,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['question_id'],
      lessonId: map['lesson_id'],
      question: map['question'],
      answer: map['answer'],
      nCorrect: map['n_correct'] ?? 0,
      nWrong: map['n_wrong'] ?? 0,
    );
  }
}

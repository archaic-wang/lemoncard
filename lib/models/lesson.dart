class Lesson {
  final int id;
  final String name;
  final String description;
  final int studentId;

  Lesson({
    required this.id,
    required this.name,
    required this.description,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'studentId': studentId,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      studentId: map['studentId'],
    );
  }
}
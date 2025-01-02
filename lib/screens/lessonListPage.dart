import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/lesson.dart';
import '../storage/lessonTable.dart';
import '../widgets/lessonList.dart';
import 'lessonDetailPage.dart';
import 'lemonTreePage.dart';

class LessonListPage extends StatefulWidget {
  final Student student;

  const LessonListPage({super.key, required this.student});

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  List<Lesson> lessons = [];
  final LessonTable lessonTable = LessonTable();

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    List<Lesson> loadedLessons = await lessonTable.getLessonsForStudent(widget.student.id);
    setState(() {
      lessons = loadedLessons;
    });
  }

  Future<void> _navigateToNewLesson() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailPage(studentId: widget.student.id),
        fullscreenDialog: true,
      ),
    );

    if (result == true) {
      _loadLessons();
    }
  }

  Future<void> _navigateToEditLesson(Lesson lesson) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailPage(lesson: lesson, studentId: widget.student.id),
        fullscreenDialog: true,
      ),
    );

    if (result == true) {
      _loadLessons();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lessons for ${widget.student.name}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _navigateToNewLesson,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: LessonList(
            lessons: lessons,
            onEdit: _navigateToEditLesson,
            onItemTap: (lesson) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LemonTreePage(lesson: lesson),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../storage/lessonTable.dart';

class LessonDetailPage extends StatefulWidget {
  final Lesson? lesson;
  final int? studentId;

  const LessonDetailPage({super.key, this.lesson, this.studentId});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final LessonTable lessonTable = LessonTable();

  @override
  void initState() {
    super.initState();
    if (widget.lesson != null) {
      _nameController.text = widget.lesson!.name;
      _descriptionController.text = widget.lesson!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveLesson() {
    if (_formKey.currentState!.validate()) {
      final newLesson = Lesson(
        id: widget.lesson?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        description: _descriptionController.text,
        studentId: widget.studentId ?? 0,
      );

      if (widget.lesson == null) {
        lessonTable.insertLesson(newLesson).then((_) {
          Navigator.pop(context, true);
        });
      } else {
        lessonTable.updateLesson(newLesson).then((_) {
          Navigator.pop(context, true);
        });
      }
    }
  }

  void _deleteLesson() {
    if (widget.lesson != null) {
      lessonTable.deleteLesson(widget.lesson!.id).then((_) {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveLesson,
                    child: const Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                  if (widget.lesson != null)
                    ElevatedButton(
                      onPressed: _deleteLesson,
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonList extends StatefulWidget {
  final List<Lesson> lessons;
  final Function(Lesson) onEdit;
  final Function(Lesson) onItemTap;

  const LessonList({
    super.key,
    required this.lessons,
    required this.onEdit,
    required this.onItemTap,
  });

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  late List<Lesson> items;

  @override
  void initState() {
    super.initState();
    items = widget.lessons;
  }

  @override
  void didUpdateWidget(covariant LessonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessons != widget.lessons) {
      setState(() {
        items = widget.lessons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(items[index].name),
            subtitle: Text(items[index].description),
            onTap: () {
              widget.onItemTap(items[index]);
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    widget.onEdit(items[index]);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
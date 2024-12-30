import 'package:flutter/material.dart';
import '../models/student.dart';

class UserList extends StatefulWidget {
  
  final List<Student> students;
  final Function(Student) onEdit;
  final Function(Student) onItemTap;

  const UserList({
    super.key, 
    required this.students, 
    required this.onEdit, 
    required this.onItemTap,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late List<Student> items;

  @override
  void initState() {
    super.initState();
    items = widget.students;
  }

  @override
  void didUpdateWidget(covariant UserList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.students != widget.students) {
      setState(() {
        items = widget.students;
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
              subtitle: Text('Age: ${items[index].age}'),
              onTap: () {
              widget.onItemTap(items[index]);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Edit button action
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
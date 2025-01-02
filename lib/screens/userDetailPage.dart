import 'package:flutter/material.dart';
import '../models/student.dart';
import '../storage/studentTable.dart';

class UserDetailPage extends StatefulWidget {
  final Student? student;

  const UserDetailPage({super.key, this.student});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final StudentTable studentTable = StudentTable();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _ageController.text = widget.student!.age.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        age: int.parse(_ageController.text),
      );

      if (widget.student == null) {
        studentTable.insertStudent(newStudent).then((_) {
          Navigator.pop(context, true);
        });
      } else {
        studentTable.updateStudent(newStudent).then((_) {
          Navigator.pop(context, true);
        });
      }
    }
  }

  void _deleteStudent() {
    if (widget.student != null) {
      studentTable.deleteStudent(widget.student!.id).then((_) {
        Navigator.pop(context, true);
      });
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
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  const Text(
                    'User Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
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
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _saveStudent,
                        child: const Text('Confirm'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      if (widget.student != null)
                        ElevatedButton(
                          onPressed: _deleteStudent,
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

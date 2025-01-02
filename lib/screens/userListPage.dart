import 'package:flutter/material.dart';
import '../widgets/userList.dart';
import '../storage/studentTable.dart';
import '../models/student.dart';
import '../screens/userDetailPage.dart';
import 'lessonListPage.dart';


class StudentCardListPage extends StatefulWidget {

  const StudentCardListPage({super.key, required this.title});
  final String title;
  
  @override
  State<StudentCardListPage> createState() => _StudentCardListPageState();
}

class _StudentCardListPageState extends State<StudentCardListPage> {

  List<Student> students = [];
  final StudentTable studentTabler = StudentTable();

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    List<Student> loadedStudents = await studentTabler.getStudents();
    setState(() {
      students = loadedStudents;
    });
  }

  Future<void> _navigateToNewStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserDetailPage(),
        fullscreenDialog: true,
      ),
    );

    if (result == true) {
      _loadStudents();
    }
  }

  Future<void> _navigateToEditStudent(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(student: student),
        fullscreenDialog: true,
      ),
    );

    if (result == true) {
      _loadStudents();
    }
  }

  Future<void> _navigateToLessonList(Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LessonListPage(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToNewStudent,
          ),
        ],
      ),
      body: UserList(
        students: students,
        onEdit: _navigateToEditStudent,
        onItemTap: _navigateToLessonList,
      ),
    );
  }
}


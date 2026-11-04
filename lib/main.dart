import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database_helper.dart';
import 'firebase_options.dart';
import 'firebase_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase before running the application
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SQLitePage(),
    );
  }
}

// PART A - SQLite
class SQLitePage extends StatefulWidget {
  const SQLitePage({super.key});

  @override
  State<SQLitePage> createState() => _SQLitePageState();
}

class _SQLitePageState extends State<SQLitePage> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  List<Map<String, dynamic>> students = [];
  int? editingId;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final data = await DatabaseHelper.instance.getStudents();
    setState(() {
      students = data;
    });
  }

  Future<void> saveStudent() async {
    if (nameController.text.isEmpty || courseController.text.isEmpty) return;
    if (editingId == null) {
      await DatabaseHelper.instance
          .insertStudent(nameController.text, courseController.text);
    } else {
      await DatabaseHelper.instance
          .updateStudent(editingId!, nameController.text, courseController.text);
      editingId = null;
    }
    nameController.clear();
    courseController.clear();
    loadStudents();
  }

  void editStudent(Map<String, dynamic> student) {
    setState(() {
      editingId = student['id'];
      nameController.text = student['name'];
      courseController.text = student['course'];
    });
  }

  Future<void> deleteStudent(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exp 8: Data Persistence (SQLite)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            tooltip: 'Firebase',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FirebasePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: 'Course'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveStudent,
                child: Text(editingId == null ? 'Add Student' : 'Update Student'),
              ),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Saved SQLite Records',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final s = students[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${s['id']}')),
                    title: Text(s['name']),
                    subtitle: Text(s['course']),
                    onTap: () => editStudent(s),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteStudent(s['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

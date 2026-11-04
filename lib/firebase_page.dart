import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// PART B - Firebase (Cloud Firestore)
class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final CollectionReference studentsRef =
      FirebaseFirestore.instance.collection('students');

  // Insert data into the Firebase collection
  Future<void> addStudent() async {
    if (nameController.text.isEmpty || courseController.text.isEmpty) return;
    await studentsRef.add({
      'name': nameController.text,
      'course': courseController.text,
    });
    nameController.clear();
    courseController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exp 8: Firebase Storage'),
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
                onPressed: addStudent,
                child: const Text('Send to Firebase'),
              ),
            ),
            const SizedBox(height: 12),
            // Retrieve and display Firebase records
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: studentsRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: const Icon(Icons.cloud_done),
                        title: Text(data['name'] ?? ''),
                        subtitle: Text(data['course'] ?? ''),
                      );
                    },
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

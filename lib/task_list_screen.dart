import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Method to add a task to Firebase Firestore
  Future<void> _addTask(String taskName) async {
    await _firebase.collection('tasks').add({
      'name': taskName,
      'isCompleted': false,
      'userId': _user?.uid,
    });
  }

  // Method to toggle task completion in Firebase
  Future<void> _toggleTaskCompletion(String taskId, bool isCompleted) async {
    await _firebase.collection('tasks').doc(taskId).update({
      'isCompleted': !isCompleted,
    });
  }

  // Method to delete a task from Firebase
  Future<void> _deleteTask(String taskId) async {
    await _firebase.collection('tasks').doc(taskId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Enter task',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      _addTask(_taskController.text);
                      _taskController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firebase
                  .collection('tasks')
                  .where('userId', isEqualTo: _user?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    return ListTile(
                      title: Text(task['name']),
                      leading: Checkbox(
                        value: task['isCompleted'],
                        onChanged: (value) {
                          _toggleTaskCompletion(task.id, task['isCompleted']);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

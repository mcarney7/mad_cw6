import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum TaskPriority { High, Medium, Low }

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  String _sortOrder = 'priority';
  bool _showCompletedTasks = true;

  void _addTask() {
    if (_taskController.text.isNotEmpty && user != null) {
      FirebaseFirestore.instance.collection('tasks').add({
        'name': _taskController.text,
        'completed': false,
        'priority': TaskPriority.Medium.toString(),
        'userId': user!.uid,
        'createdAt': Timestamp.now(),
      });
      _taskController.clear();
    }
  }

  void _deleteTask(String id) {
    FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  void _toggleComplete(DocumentSnapshot task) {
    FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
      'completed': !task['completed'],
    });
  }

  void _setPriority(DocumentSnapshot task, String priority) {
    FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
      'priority': priority,
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'TaskPriority.High':
        return Colors.red;
      case 'TaskPriority.Medium':
        return Colors.yellow;
      case 'TaskPriority.Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        backgroundColor: Colors.teal,
        actions: [
          DropdownButton<String>(
            value: _sortOrder,
            items: <String>['priority', 'createdAt', 'completed']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.replaceAll('_', ' ').toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _sortOrder = newValue!;
              });
            },
          ),
          Switch(
            value: _showCompletedTasks,
            onChanged: (value) {
              setState(() {
                _showCompletedTasks = value;
              });
            },
            activeColor: Colors.teal,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.teal),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy(_sortOrder)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var tasks = snapshot.data!.docs.where((task) {
                  if (!_showCompletedTasks && task['completed']) return false;
                  return true;
                }).toList();

                return ListView(
                  children: tasks.map((task) {
                    return ListTile(
                      title: Text(
                        task['name'],
                        style: TextStyle(
                          color: _getPriorityColor(task['priority']),
                          decoration: task['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task['completed'],
                        onChanged: (_) => _toggleComplete(task),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            value: task['priority'],
                            items: TaskPriority.values.map((priority) {
                              return DropdownMenuItem<String>(
                                value: priority.toString(),
                                child: Text(priority.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (String? value) =>
                                _setPriority(task, value!),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

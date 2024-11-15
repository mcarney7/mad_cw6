import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeSlotController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedPriority = 'Medium';
  String _filter = 'All';
  String _sortOrder = 'Priority';

  void _addTask(String taskName, String day, String timeSlot, String priority) {
    if (taskName.isNotEmpty && day.isNotEmpty && timeSlot.isNotEmpty) {
      final task = TaskModel(
        id: '',
        name: taskName,
        priority: priority,
        completed: false,
        user: 'currentUserId', // Replace with authenticated user's ID
        day: day,
        timeSlot: timeSlot,
        dueDate: DateTime.now().add(Duration(days: 1)), // Default due date
      );
      _firestore.collection('tasks').add(task.toMap());
      _taskController.clear();
      _dayController.clear();
      _timeSlotController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          DropdownButton<String>(
            value: _sortOrder,
            items: ['Priority', 'Due Date', 'Completion']
                .map((sort) => DropdownMenuItem(value: sort, child: Text(sort)))
                .toList(),
            onChanged: (value) {
              setState(() => _sortOrder = value ?? 'Priority');
            },
          ),
          DropdownButton<String>(
            value: _filter,
            items: ['All', 'Completed', 'Incomplete']
                .map((filter) => DropdownMenuItem(value: filter, child: Text(filter)))
                .toList(),
            onChanged: (value) {
              setState(() => _filter = value ?? 'All');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                ),
              ),
              DropdownButton<String>(
                value: _selectedPriority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedPriority = value ?? 'Medium');
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dayController,
                  decoration: InputDecoration(labelText: 'Day (e.g., Monday)'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _timeSlotController,
                  decoration: InputDecoration(labelText: 'Time Slot (e.g., 9 am - 10 am)'),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => _addTask(
              _taskController.text,
              _dayController.text,
              _timeSlotController.text,
              _selectedPriority,
            ),
            child: Text('Add Task'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('tasks').orderBy('dueDate').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                List<TaskModel> tasks = snapshot.data!.docs.map((doc) {
                  return TaskModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                // Apply filtering
                if (_filter != 'All') {
                  tasks = tasks.where((task) {
                    if (_filter == 'Completed') return task.completed;
                    return !task.completed;
                  }).toList();
                }

                // Apply sorting
                if (_sortOrder == 'Priority') {
                  tasks.sort((a, b) => a.priority.compareTo(b.priority));
                }

                // Group tasks by day and time slot
                Map<String, List<TaskModel>> groupedTasks = {};
                for (var task in tasks) {
                  final key = '${task.day}-${task.timeSlot}';
                  groupedTasks.putIfAbsent(key, () => []).add(task);
                }

                return ListView(
                  children: groupedTasks.entries.map((entry) {
                    return ExpansionTile(
                      title: Text(entry.key),
                      children: entry.value.map((task) {
                        return ListTile(
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (value) {
                              _firestore.collection('tasks').doc(task.id).update({'completed': value});
                            },
                          ),
                          title: Text(task.name),
                          subtitle: Text(
                            'Priority: ${task.priority}',
                            style: TextStyle(
                              color: task.priority == 'High'
                                  ? Colors.red
                                  : task.priority == 'Medium'
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _firestore.collection('tasks').doc(task.id).delete();
                            },
                          ),
                        );
                      }).toList(),
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

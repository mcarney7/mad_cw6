class TaskModel {
  final String id;
  final String name;
  final String priority;
  final bool completed;
  final String user;
  final String day; // e.g., Monday, Tuesday
  final String timeSlot; // e.g., 9 am - 10 am
  final DateTime dueDate;

  TaskModel({
    required this.id,
    required this.name,
    required this.priority,
    required this.completed,
    required this.user,
    required this.day,
    required this.timeSlot,
    required this.dueDate,
  });

  // Convert TaskModel object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priority': priority,
      'completed': completed,
      'user': user,
      'day': day,
      'timeSlot': timeSlot,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Create TaskModel object from Map
  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      name: map['name'] ?? '',
      priority: map['priority'] ?? 'Medium',
      completed: map['completed'] ?? false,
      user: map['user'] ?? '',
      day: map['day'] ?? 'Unknown',
      timeSlot: map['timeSlot'] ?? 'All Day',
      dueDate: DateTime.parse(map['dueDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}

enum Priority { low, medium, high }

class Task {
  String id;
  String title;
  String description;
  DateTime? dueDate;
  DateTime? reminderTime;
  Priority priority;
  String category;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.reminderTime,
    this.priority = Priority.medium,
    this.category = 'General',
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate?.millisecondsSinceEpoch,
    'reminderTime': reminderTime?.millisecondsSinceEpoch,
    'priority': priority.index,
    'category': category,
    'isCompleted': isCompleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    dueDate: json['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dueDate']) : null,
    reminderTime: json['reminderTime'] != null ? DateTime.fromMillisecondsSinceEpoch(json['reminderTime']) : null,
    priority: Priority.values[json['priority'] ?? 1],
    category: json['category'] ?? 'General',
    isCompleted: json['isCompleted'] ?? false,
  );
}
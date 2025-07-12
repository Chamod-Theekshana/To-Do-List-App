import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(elevation: 2, margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Task> tasks = [];
  bool showCompleted = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _addTask(String title, String description, DateTime? dueDate) {
    setState(() {
      tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        dueDate: dueDate,
      ));
    });
    _saveTasks();
  }

  void _editTask(String id, String title, String description, DateTime? dueDate) {
    setState(() {
      final task = tasks.firstWhere((t) => t.id == id);
      task.title = title;
      task.description = description;
      task.dueDate = dueDate;
    });
    _saveTasks();
  }

  void _deleteTask(String id) {
    setState(() {
      tasks.removeWhere((t) => t.id == id);
    });
    _saveTasks();
  }

  void _toggleTask(String id) {
    setState(() {
      final task = tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  List<Task> get filteredTasks {
    return showCompleted ? tasks : tasks.where((t) => !t.isCompleted).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('My Tasks', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(showCompleted ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => showCompleted = !showCompleted),
            tooltip: showCompleted ? 'Hide completed' : 'Show completed',
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text('No tasks yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  Text('Tap + to add your first task', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleTask(task.id),
                      activeColor: Colors.green,
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey[600] : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: (task.description.isNotEmpty || task.dueDate != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (task.description.isNotEmpty)
                                Text(task.description, style: TextStyle(color: Colors.grey[700])),
                              if (task.dueDate != null)
                                Container(
                                  margin: EdgeInsets.only(top: 4),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Due: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                                    style: TextStyle(fontSize: 12, color: Colors.orange[800]),
                                  ),
                                ),
                            ],
                          )
                        : null,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showTaskDialog(task: task);
                        } else if (value == 'delete') {
                          _deleteTask(task.id);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descController = TextEditingController(text: task?.description ?? '');
    DateTime? selectedDate = task?.dueDate;
    String? titleError;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            task == null ? 'Add New Task' : 'Edit Task',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  errorText: titleError,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.title),
                ),
                onChanged: (_) => setDialogState(() => titleError = null),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('Due Date: '),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setDialogState(() => selectedDate = date);
                          }
                        },
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Select Date',
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                    ),
                    if (selectedDate != null)
                      IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: () => setDialogState(() => selectedDate = null),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  setDialogState(() => titleError = 'Title is required');
                  return;
                }
                if (task == null) {
                  _addTask(title, descController.text.trim(), selectedDate);
                } else {
                  _editTask(task.id, title, descController.text.trim(), selectedDate);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(task == null ? 'Add Task' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
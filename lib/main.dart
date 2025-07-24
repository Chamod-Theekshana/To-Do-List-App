import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
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
  String searchQuery = '';
  String selectedCategory = 'All';
  Priority? selectedPriority;
  String sortBy = 'created';

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

  void _addTask(
    String title,
    String description,
    DateTime? dueDate,
    DateTime? reminderTime,
    Priority priority,
    String category,
  ) {
    setState(() {
      tasks.add(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          description: description,
          dueDate: dueDate,
          reminderTime: reminderTime,
          priority: priority,
          category: category,
        ),
      );
    });
    _saveTasks();
    NotificationService.showTaskAddedNotification(title);
  }

  void _editTask(
    String id,
    String title,
    String description,
    DateTime? dueDate,
    DateTime? reminderTime,
    Priority priority,
    String category,
  ) {
    setState(() {
      final task = tasks.firstWhere((t) => t.id == id);
      task.title = title;
      task.description = description;
      task.dueDate = dueDate;
      task.reminderTime = reminderTime;
      task.priority = priority;
      task.category = category;
    });
    _saveTasks();
  }

  void _deleteTask(String id) {
    final task = tasks.firstWhere((t) => t.id == id);
    final taskTitle = task.title;
    setState(() {
      tasks.removeWhere((t) => t.id == id);
    });
    _saveTasks();
    NotificationService.showTaskDeletedNotification(taskTitle);
  }

  void _toggleTask(String id) {
    setState(() {
      final task = tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
    _saveTasks();
  }

  List<Task> get filteredTasks {
    var filtered = tasks.where((t) => showCompleted || !t.isCompleted);

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where(
        (t) =>
            t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            t.description.toLowerCase().contains(searchQuery.toLowerCase()),
      );
    }

    if (selectedCategory != 'All') {
      filtered = filtered.where((t) => t.category == selectedCategory);
    }

    if (selectedPriority != null) {
      filtered = filtered.where((t) => t.priority == selectedPriority);
    }

    var result = filtered.toList();

    switch (sortBy) {
      case 'priority':
        result.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'dueDate':
        result.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      default:
        result.sort((a, b) => b.id.compareTo(a.id));
    }

    return result;
  }

  Set<String> get categories {
    return {'All', ...tasks.map((t) => t.category).toSet()};
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
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: Icon(showCompleted ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => showCompleted = !showCompleted),
            tooltip: showCompleted ? 'Hide completed' : 'Show completed',
          ),
        ],
      ),
      body:
          filteredTasks.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'No tasks yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    Text(
                      'Tap + to add your first task',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTask(task.id),
                        activeColor: Colors.green,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration:
                              task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                          color: task.isCompleted ? Colors.grey[600] : null,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.description.isNotEmpty)
                            Text(
                              task.description,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      task.priority == Priority.high
                                          ? Colors.red[100]
                                          : task.priority == Priority.medium
                                          ? Colors.orange[100]
                                          : Colors.green[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  task.priority.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  task.category,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              if (task.dueDate != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Due: ${task.dueDate!.day}/${task.dueDate!.month}',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
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
    final categoryController = TextEditingController(
      text: task?.category ?? 'General',
    );
    DateTime? selectedDate = task?.dueDate;
    DateTime? reminderTime = task?.reminderTime;
    Priority selectedPriority = task?.priority ?? Priority.medium;
    String? titleError;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    task == null ? 'Add New Task' : 'Edit Task',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title *',
                            errorText: titleError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.title),
                          ),
                          onChanged:
                              (_) => setDialogState(() => titleError = null),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: descController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: categoryController,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.category),
                          ),
                        ),
                        SizedBox(height: 12),
                        DropdownButtonFormField<Priority>(
                          value: selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.flag),
                          ),
                          items:
                              Priority.values
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(p.name.toUpperCase()),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (p) =>
                                  setDialogState(() => selectedPriority = p!),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                  );
                                  if (date != null)
                                    setDialogState(() => selectedDate = date);
                                },
                                child: Text(
                                  selectedDate != null
                                      ? 'Due: ${selectedDate!.day}/${selectedDate!.month}'
                                      : 'Set Due Date',
                                ),
                              ),
                            ),
                            if (selectedDate != null)
                              IconButton(
                                icon: Icon(Icons.clear, size: 18),
                                onPressed:
                                    () => setDialogState(
                                      () => selectedDate = null,
                                    ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: reminderTime ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                  );
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                        reminderTime ?? DateTime.now(),
                                      ),
                                    );
                                    if (time != null) {
                                      setDialogState(
                                        () =>
                                            reminderTime = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                              time.hour,
                                              time.minute,
                                            ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  reminderTime != null
                                      ? 'Reminder: ${reminderTime!.day}/${reminderTime!.month} ${reminderTime!.hour}:${reminderTime!.minute.toString().padLeft(2, '0')}'
                                      : 'Set Reminder',
                                ),
                              ),
                            ),
                            if (reminderTime != null)
                              IconButton(
                                icon: Icon(Icons.clear, size: 18),
                                onPressed:
                                    () => setDialogState(
                                      () => reminderTime = null,
                                    ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          setDialogState(
                            () => titleError = 'Title is required',
                          );
                          return;
                        }
                        if (task == null) {
                          _addTask(
                            title,
                            descController.text.trim(),
                            selectedDate,
                            reminderTime,
                            selectedPriority,
                            categoryController.text.trim(),
                          );
                        } else {
                          _editTask(
                            task.id,
                            title,
                            descController.text.trim(),
                            selectedDate,
                            reminderTime,
                            selectedPriority,
                            categoryController.text.trim(),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text(task == null ? 'Add' : 'Save'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Search Tasks'),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter search term'),
              onChanged: (value) => setState(() => searchQuery = value),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() => searchQuery = '');
                  Navigator.pop(context);
                },
                child: Text('Clear'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Done'),
              ),
            ],
          ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text('Filter & Sort'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(labelText: 'Category'),
                        items:
                            categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (c) => setDialogState(() => selectedCategory = c!),
                      ),
                      DropdownButtonFormField<Priority?>(
                        value: selectedPriority,
                        decoration: InputDecoration(labelText: 'Priority'),
                        items: [
                          DropdownMenuItem<Priority?>(
                            value: null,
                            child: Text('All'),
                          ),
                          ...Priority.values.map(
                            (p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            ),
                          ),
                        ],
                        onChanged:
                            (p) => setDialogState(() => selectedPriority = p),
                      ),
                      DropdownButtonFormField<String>(
                        value: sortBy,
                        decoration: InputDecoration(labelText: 'Sort by'),
                        items: [
                          DropdownMenuItem(
                            value: 'created',
                            child: Text('Date Created'),
                          ),
                          DropdownMenuItem(
                            value: 'dueDate',
                            child: Text('Due Date'),
                          ),
                          DropdownMenuItem(
                            value: 'priority',
                            child: Text('Priority'),
                          ),
                        ],
                        onChanged: (s) => setDialogState(() => sortBy = s!),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setDialogState(() {
                          selectedCategory = 'All';
                          selectedPriority = null;
                          sortBy = 'created';
                        });
                        setState(() {
                          selectedCategory = 'All';
                          selectedPriority = null;
                          sortBy = 'created';
                        });
                      },
                      child: Text('Reset'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text('Apply'),
                    ),
                  ],
                ),
          ),
    );
  }
}

# Flutter Todo App

A feature-rich todo application built with Flutter that helps you organize and manage your tasks efficiently.

## Features

### Core Functionality
- ✅ Create, edit, and delete tasks
- ✅ Mark tasks as complete/incomplete
- ✅ Persistent storage using SharedPreferences

### Advanced Features
- 🎯 **Priority Levels**: Set tasks as Low, Medium, or High priority
- 📁 **Categories**: Organize tasks with custom categories (Work, Personal, etc.)
- 📅 **Due Dates**: Set deadlines for your tasks
- ⏰ **Reminders**: Set notification times for important tasks
- 🔍 **Search**: Find tasks by title or description
- 🔧 **Filter & Sort**: Filter by category, priority, completion status
- 📊 **Sort Options**: Sort by creation date, due date, or priority

## Screenshots

*Add screenshots of your app here*

## Getting Started

### Prerequisites
- Flutter SDK (>=2.0.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd todo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15
```

## Usage

### Creating Tasks
1. Tap the **+** button
2. Fill in task details:
   - Title (required)
   - Description (optional)
   - Category
   - Priority level
   - Due date
   - Reminder time
3. Tap **Add** to save

### Managing Tasks
- **Complete**: Tap the checkbox
- **Edit**: Tap the menu (⋮) and select Edit
- **Delete**: Tap the menu (⋮) and select Delete

### Search & Filter
- **Search**: Tap the search icon in the app bar
- **Filter**: Tap the filter icon to filter by category, priority, or sort options
- **Toggle Completed**: Use the visibility icon to show/hide completed tasks

## Project Structure

```
lib/
├── main.dart          # Main app entry point
├── task.dart          # Task model and Priority enum
└── ...
```

## Key Components

### Task Model
- `Task` class with properties: id, title, description, dueDate, reminderTime, priority, category, isCompleted
- `Priority` enum: low, medium, high
- JSON serialization for persistent storage

### Main Features
- **TodoList**: Main widget managing task state
- **Task Dialog**: Form for creating/editing tasks
- **Search Dialog**: Search functionality
- **Filter Dialog**: Advanced filtering and sorting options

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Future Enhancements

- [ ] Push notifications for reminders
- [ ] Task sharing
- [ ] Dark theme support
- [ ] Export/Import functionality
- [ ] Task statistics and analytics

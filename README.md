# Flutter Todo App

A feature-rich todo application built with Flutter that helps you organize and manage your tasks efficiently.

## Features

### Core Functionality
- ✅ Create, edit, and delete tasks
- ✅ Mark tasks as complete/incomplete
- ✅ Persistent storage using SharedPreferences
- ✅ Clean and intuitive Material Design UI

### Advanced Features
- 🎯 **Priority Levels**: Set tasks as Low, Medium, or High priority with color coding
- 📁 **Categories**: Organize tasks with custom categories (Work, Personal, etc.)
- 📅 **Due Dates**: Set deadlines for your tasks
- ⏰ **Reminders**: Set notification times for important tasks
- 🔍 **Search**: Find tasks by title or description
- 🔧 **Filter & Sort**: Filter by category, priority, completion status
- 📊 **Sort Options**: Sort by creation date, due date, or priority
- 💾 **State Persistence**: Tasks automatically saved using SharedPreferences
- 🔔 **Notifications**: Local notifications for task reminders
- 👁️ **Task Visibility**: Toggle completed tasks visibility

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
git clone https://github.com/Chamod-Theekshana/To-Do-List-App.git
cd To-Do-List-App
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
  flutter_local_notifications: ^latest_version # For task reminders
```

## Usage

### Creating Tasks
1. Tap the **+** button
2. Fill in task details:
   - Title (required)
   - Description (optional)
   - Category
   - Priority level (Low/Medium/High)
   - Due date
   - Reminder time
3. Tap **Add** to save

### Managing Tasks
- **Complete**: Tap the checkbox next to task
- **Edit**: Tap the menu (⋮) and select Edit
- **Delete**: Tap the menu (⋮) and select Delete
- **View Details**: Tap on the task to see full description

### Search & Filter
- **Search**: Tap the search icon in the app bar to search by title/description
- **Filter**: Tap the filter icon to:
  - Filter by category
  - Filter by priority level
  - Sort by creation date/due date/priority
- **Toggle Completed**: Use the visibility icon to show/hide completed tasks

## Project Structure

```
lib/
├── main.dart               # Main app entry point and UI implementation
├── task.dart              # Task model and Priority enum
├── services/
│   └── notification_service.dart  # Notification handling
└── widgets/              # Reusable UI components
```

## Key Components

### Task Model
- `Task` class with properties:
  - id: Unique identifier
  - title: Task name
  - description: Detailed task description
  - dueDate: Task deadline
  - reminderTime: Notification time
  - priority: Priority enum (low, medium, high)
  - category: Task category
  - isCompleted: Completion status

### Main Features
- **TodoList**: Main widget managing task state and UI
- **Task Dialog**: Form for creating/editing tasks
- **Search Dialog**: Search functionality with real-time filtering
- **Filter Dialog**: Advanced filtering and sorting options
- **NotificationService**: Local notifications management

## Testing

Run the tests using:
```bash
flutter test
```

The project includes widget tests to ensure core functionality works as expected.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
6. Push to the branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Future Enhancements

- [ ] Push notifications for reminders
- [ ] Task sharing between users
- [ ] Dark theme support with theme toggling
- [ ] Export/Import functionality (JSON/CSV)
- [ ] Task statistics and analytics dashboard
- [ ] Cloud sync support
- [ ] Recurring tasks
- [ ] Task priority auto-suggestion
- [ ] Custom task categories with icons
- [ ] Task attachments support

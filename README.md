# 📝 TodoGo

> **A beautiful, feature-rich todo application built with Flutter**

TodoGo helps you organize and manage your tasks efficiently with a clean, intuitive interface and powerful features.

## Features

### ✨ Core Functionality
- ✅ **Task Management**: Create, edit, and delete tasks effortlessly
- ✅ **Progress Tracking**: Mark tasks as complete/incomplete with visual feedback
- ✅ **Data Persistence**: Automatic saving using SharedPreferences
- ✅ **Beautiful UI**: Clean and intuitive Material Design interface
- ✅ **Custom Branding**: Beautiful TodoGo icon and splash screen

### 🚀 Advanced Features
- 🎯 **Smart Prioritization**: Color-coded priority levels (Low, Medium, High)
- 📁 **Category Organization**: Custom categories (Work, Personal, Shopping, etc.)
- 📅 **Deadline Management**: Set and track due dates
- ⏰ **Smart Reminders**: Custom notification times with TodoGo branding
- 🔍 **Instant Search**: Real-time search by title or description
- 🔧 **Advanced Filtering**: Filter by category, priority, and completion status
- 📊 **Flexible Sorting**: Sort by creation date, due date, or priority
- 💾 **Auto-Save**: Seamless state persistence across app sessions
- 🔔 **Rich Notifications**: Custom TodoGo notifications for all platforms
- 👁️ **View Control**: Toggle completed tasks visibility
- 🎨 **Cross-Platform**: Consistent experience on Android, iOS, Web, Windows, and macOS

## 📱 Screenshots

<div align="center">
  <img src="assets/images/todo.png" alt="TodoGo Icon" width="100" height="100">
  <br>
  <em>Beautiful custom icon and splash screen</em>
</div>

*Screenshots coming soon - Experience TodoGo yourself!*

## Getting Started

### 📋 Prerequisites
- **Flutter SDK** (>=3.7.2)
- **Dart SDK** (included with Flutter)
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Device**: Android/iOS device, emulator, or web browser
- **Platform Support**: Android, iOS, Web, Windows, macOS, Linux

### Installation

1. Clone the repository:
```bash
git clone <your-repository-url>
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
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.0

dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.10
```

## Usage

### 📝 Creating Tasks
1. **Tap** the floating **+** button
2. **Fill** in your task details:
   - 📌 **Title** (required) - What needs to be done?
   - 📄 **Description** (optional) - Additional details
   - 🏷️ **Category** - Organize your tasks
   - 🎯 **Priority** - Low, Medium, or High
   - 📅 **Due Date** - Set your deadline
   - ⏰ **Reminder** - Never miss important tasks
3. **Save** and watch your productivity soar!

### ⚡ Managing Tasks
- ✅ **Complete**: Tap the checkbox for instant satisfaction
- ✏️ **Edit**: Tap the menu (⋮) to modify details
- 🗑️ **Delete**: Remove completed or unwanted tasks
- 👀 **View Details**: Tap any task to see full information
- 🔔 **Smart Notifications**: Get reminded with TodoGo's custom notifications

### 🔍 Search & Filter Magic
- **🔎 Instant Search**: Find tasks by title or description in real-time
- **🔧 Smart Filters**: 
  - 🏷️ Filter by category (Work, Personal, etc.)
  - 🎯 Filter by priority level
  - ✅ Filter by completion status
- **📊 Flexible Sorting**:
  - 📅 Sort by creation date
  - ⏰ Sort by due date
  - 🎯 Sort by priority
- **👁️ View Control**: Toggle completed tasks visibility with one tap

## 🏗️ Project Structure

```
todo/
├── lib/
│   ├── main.dart                    # Main app entry point and UI
│   ├── task.dart                    # Task model and Priority enum
│   └── services/
│       └── notification_service.dart # Notification handling
├── assets/
│   └── images/
│       └── todo.png                 # App icon and splash screen
├── android/                         # Android-specific files
├── ios/                            # iOS-specific files
├── web/                            # Web-specific files
└── pubspec.yaml                    # Dependencies and configuration
```

## 🔧 Key Components

### 📋 Task Model
Powerful `Task` class with comprehensive properties:
- **🆔 id**: Unique identifier for each task
- **📌 title**: Clear, concise task name
- **📄 description**: Detailed task information
- **📅 dueDate**: Deadline tracking
- **⏰ reminderTime**: Smart notification scheduling
- **🎯 priority**: Priority enum (Low, Medium, High)
- **🏷️ category**: Flexible task categorization
- **✅ isCompleted**: Real-time completion status

### 🎯 Main Features
- **🏠 TodoList**: Beautiful main interface managing all task operations
- **📝 Task Dialog**: Intuitive form for creating and editing tasks
- **🔍 Search Dialog**: Lightning-fast search with real-time filtering
- **🔧 Filter Dialog**: Advanced filtering and sorting capabilities
- **🔔 NotificationService**: Smart notification system with TodoGo branding
- **🎨 Custom Theming**: Consistent TodoGo branding across all platforms
- **💾 Data Persistence**: Reliable task storage and retrieval

## 🧪 Testing

Run the tests using:
```bash
flutter test
```

The project includes widget tests to ensure core functionality works as expected.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
6. Push to the branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🚀 Future Enhancements

### 🔔 Notifications & Reminders
- [ ] Push notifications for reminders
- [ ] Smart notification scheduling
- [ ] Custom notification sounds

### 👥 Collaboration
- [ ] Task sharing between users
- [ ] Team workspaces
- [ ] Real-time collaboration

### 🎨 Customization
- [ ] Dark theme support with theme toggling
- [ ] Custom task categories with icons
- [ ] Personalized color schemes
- [ ] Widget customization

### 📊 Analytics & Export
- [ ] Task statistics and analytics dashboard
- [ ] Export/Import functionality (JSON/CSV)
- [ ] Progress tracking and insights
- [ ] Productivity reports

### ☁️ Cloud & Sync
- [ ] Cloud sync support
- [ ] Cross-device synchronization
- [ ] Backup and restore

### ⚡ Advanced Features
- [ ] Recurring tasks
- [ ] Task priority auto-suggestion
- [ ] Task attachments support
- [ ] Voice input for tasks
- [ ] AI-powered task suggestions

---

<div align="center">
  <h3>🌟 Made with ❤️ using Flutter</h3>
  <p><strong>TodoGo</strong> - Your productivity companion</p>
</div>

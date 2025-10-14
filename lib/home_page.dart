import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'templates/models.dart';
import 'templates/todo_detail_page.dart';
import 'templates/reminder_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Home - Created Pages')),
      body: ListView.builder(
        itemCount: appState.pages.length,
        itemBuilder: (context, index) {
          final page = appState.pages[index];
          return ListTile(
            title: Text(page.title),
            subtitle: Text(page is ToDoPageModel ? 'ToDo List' : 'Reminder'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => page is ToDoPageModel
                    ? ToDoDetailPage(page: page)
                    : ReminderDetailPage(page: page as ReminderPageModel),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showTemplateChooser(context),
      ),
    );
  }

  void _showTemplateChooser(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('ToDo List'),
              onTap: () => _createPage(context, PageType.todo),
            ),
            ListTile(
              title: const Text('Reminder'),
              onTap: () => _createPage(context, PageType.reminder),
            ),
          ],
        ),
      ),
    );
  }

  void _createPage(BuildContext context, PageType type) {
    Navigator.pop(context); // Close dialog
    final TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Title'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Page Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final appState = Provider.of<AppState>(context, listen: false);
                late PageModel newPage;
                if (type == PageType.todo) {
                  newPage = ToDoPageModel(title: titleController.text);
                } else {
                  newPage = ReminderPageModel(title: titleController.text);
                }
                appState.addPage(newPage);
                Navigator.pop(context); // Close title dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => type == PageType.todo
                        ? ToDoDetailPage(page: newPage as ToDoPageModel)
                        : ReminderDetailPage(page: newPage as ReminderPageModel),
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
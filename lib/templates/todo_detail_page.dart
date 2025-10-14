import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';
import 'models.dart';

class ToDoDetailPage extends StatefulWidget {
  final ToDoPageModel page;
  const ToDoDetailPage({super.key, required this.page});

  @override
  State<ToDoDetailPage> createState() => _ToDoDetailPageState();
}

class _ToDoDetailPageState extends State<ToDoDetailPage> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.page.title)),
      body: ListView.builder(
        itemCount: widget.page.items.length,
        itemBuilder: (context, index) {
          final item = widget.page.items[index];
          return ListTile(
            title: Text(item.text),
            subtitle: item.dueDate != null ? Text(DateFormat('yyyy-MM-dd').format(item.dueDate!)) : null,
            leading: Checkbox(
              value: item.completed,
              onChanged: (val) {
                setState(() => item.completed = val!);
                Provider.of<AppState>(context, listen: false).notifyListeners();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add Task'),
            content: TextField(
              controller: _taskController,
              decoration: const InputDecoration(hintText: 'Task Text'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (_taskController.text.isNotEmpty) {
                    final dueDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    setState(() {
                      widget.page.items.add(ToDoItem(text: _taskController.text, dueDate: dueDate));
                    });
                    _taskController.clear();
                    Navigator.pop(context);
                    Provider.of<AppState>(context, listen: false).notifyListeners();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';
import 'models.dart';

class ReminderDetailPage extends StatefulWidget {
  final ReminderPageModel page;
  const ReminderDetailPage({super.key, required this.page});

  @override
  State<ReminderDetailPage> createState() => _ReminderDetailPageState();
}

class _ReminderDetailPageState extends State<ReminderDetailPage> {
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descController.text = widget.page.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.page.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (val) {
                widget.page.description = val;
                Provider.of<AppState>(context, listen: false).notifyListeners();
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: widget.page.dateTime ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(widget.page.dateTime ?? DateTime.now()),
                  );
                  if (time != null) {
                    setState(() {
                      widget.page.dateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                    Provider.of<AppState>(context, listen: false).notifyListeners();
                  }
                }
              },
              child: Text(widget.page.dateTime != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(widget.page.dateTime!)
                  : 'Set Date & Time'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'templates/models.dart';

class AppState extends ChangeNotifier {
  List<PageModel> pages = [];

  void addPage(PageModel page) {
    pages.add(page);
    notifyListeners();
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    List<Map<String, dynamic>> events = [];
    for (var page in pages) {
      if (page is ToDoPageModel) {
        for (var item in page.items) {
          if (item.dueDate != null && isSameDay(item.dueDate!, day)) {
            events.add({
              'title': '${page.title} - ${item.text}',
              'type': 'ToDo',
              'date': item.dueDate,
            });
          }
        }
      } else if (page is ReminderPageModel && page.dateTime != null && isSameDay(page.dateTime!, day)) {
        events.add({
          'title': page.title,
          'type': 'Reminder',
          'date': page.dateTime,
        });
      }
    }
    return events;
  }
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
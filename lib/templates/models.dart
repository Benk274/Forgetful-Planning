enum PageType { todo, reminder }

abstract class PageModel {
  String title;
  PageModel({required this.title});
}

class ToDoPageModel extends PageModel {
  List<ToDoItem> items = [];
  ToDoPageModel({required super.title});
}

class ToDoItem {
  String text;
  DateTime? dueDate;
  bool completed;
  ToDoItem({required this.text, this.dueDate, this.completed = false});
}

class ReminderPageModel extends PageModel {
  String description = '';
  DateTime? dateTime;
  ReminderPageModel({required super.title});
}
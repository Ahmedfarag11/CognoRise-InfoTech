import 'package:hive_flutter/hive_flutter.dart';

//-----refrence hivebox----
class ToDodatabase {
  List todolist = [];
  final _mybox = Hive.box('Mybox');

// when user first time use app
  void createInitialdata() {
    todolist = [
      ['make tutorial', false],
      ['Do tasks', false]
    ];
  }

// Get data from data base
  void getdata() {
    todolist = _mybox.get('ToDolist');
  }

  void updatedata() {
    _mybox.put('ToDolist', todolist);
  }
}

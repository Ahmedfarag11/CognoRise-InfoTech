import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/dialog_box.dart';
import 'package:todoapp/todo_item.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  // Reference hive box
  final _mybox = Hive.box('Mybox');
  ToDodatabase db = ToDodatabase();

  // Store the filtered todo list to search
  List _filteredTodoList = [];

  @override
  void initState() {
    // If this is the first time using the app, use default data
    if (_mybox.get('ToDolist') == null) {
      db.createInitialdata();
    } else {
      // If already using the app, get existing data
      db.getdata();
    }
    // Initialize with all items
    _filteredTodoList = db.todolist;
    super.initState();
  }

  // --------Checkbox Handler------------
  void Checkboxchanged(bool? value, int index) {
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
    });
    db.updatedata();
  }

  // ------Save New Task------
  void savenewtask() {
    setState(() {
      db.todolist.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updatedata();
    _filterTasks(""); // Reset filter after adding new task
  }

  //------------New Task Creation--------------
  void createnewtask() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialogbox(
          controller: _controller,
          onsave: savenewtask,
          oncancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // ---------Delete Task------------
  void deletetask(int index) {
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updatedata();
    _filterTasks(""); // Reset filter after deleting task
  }

  //----------Text Controller-----------
  final _controller = TextEditingController();

  // ------------Search Functionality------------
  void _filterTasks(String query) {
    List filteredList = db.todolist.where((task) {
      String taskName = task[0].toString().toLowerCase();
      return taskName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredTodoList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery for responsive design
    var screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(screenSize.height * 0.05),
            ),
          ),
          backgroundColor: Colors.yellow,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'TO DO',
              style: TextStyle(
                fontSize: screenSize.width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          elevation: 0,
        ),
        //------------------------------
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          onPressed: createnewtask,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: screenSize.width * 0.08,
          ),
        ),
        //------------------------------
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.03,
          ),
          child: Column(
            children: [
              searchBox(screenSize),
              SizedBox(height: screenSize.height * 0.03),
              //---------------------------------------------
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredTodoList.length,
                  itemBuilder: (context, index) {
                    return TodoItem(
                      taskname: _filteredTodoList[index][0],
                      taskcompleted: _filteredTodoList[index][1],
                      onchanged: (value) => Checkboxchanged(value, index),
                      deletefunction: (BuildContext) => deletetask(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search Box Widget
  Widget searchBox(Size screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenSize.width * 0.05),
      ),
      child: TextField(
        onChanged: (value) =>
            _filterTasks(value), // Filter tasks on search input
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.02),
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: screenSize.width * 0.07,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: screenSize.width * 0.08,
            maxWidth: screenSize.width * 0.08,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: screenSize.width * 0.05,
          ),
        ),
      ),
    );
  }
}

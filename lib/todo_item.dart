import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

//-----------variables------------------
//ignore: must_be_immutable
class TodoItem extends StatelessWidget {
  final String taskname;
  final bool taskcompleted;
  Function(bool?)? onchanged;
  Function(BuildContext)? deletefunction;

  TodoItem({
    super.key,
    required this.taskname,
    required this.taskcompleted,
    required this.onchanged,
    required this.deletefunction,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding:
          EdgeInsets.only(bottom: screenHeight * 0.03), 
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deletefunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08, 
              vertical: screenHeight * 0.02, 
            ),
            leading: Checkbox(
              value: taskcompleted,
              onChanged: onchanged,
              activeColor: Colors.blue,
            ),
            title: Text(
              taskname,
              style: TextStyle(
                fontSize: screenWidth *
                    0.045, 
                fontWeight: FontWeight.w600,
                decoration: taskcompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

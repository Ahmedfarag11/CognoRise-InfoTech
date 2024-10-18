import 'package:flutter/material.dart';
import 'package:todoapp/mybuttons.dart';

// ignore: must_be_immutable
class Dialogbox extends StatelessWidget {
  final TextEditingController controller;
  VoidCallback onsave;
  VoidCallback oncancel;

  Dialogbox({
    super.key,
    required this.controller,
    required this.onsave,
    required this.oncancel,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsive design
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: Container(
        height: screenHeight * 0.25, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //--------user input--------------
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                hintText: 'Add a new Task',
              ),
            ),
            //------------save and cancel Buttons--------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //save button
                Mybutton(
                  text: 'Save',
                  onpressed: onsave,
                ),

                //cancel button
                Mybutton(
                  text: 'Cancel',
                  onpressed: oncancel,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

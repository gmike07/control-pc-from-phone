import 'package:flutter/material.dart';



class InstructionPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<InstructionPage> {
  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Instructions:",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "1. scan the qrCode on the pc with the app",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "2. you will go to a window with a lot of things on it:",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "\t a. keyboard controls have:",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "\t\t i. a bar in which you can type things to the pc\n" +
              "\t\t ii. a clear button to clear the bar\n" +
              "\t\t iii. a enter button to press enter on the pc\n" +
              "\t\t vi. a send button to type the bar to the pc\n" + 
              "\t\t v. a erase button to press backspace on the pc",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "\t b. mouse controls have:",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "\t\t i. a joystick to control the mouse\n" +
              "\t\t ii. click once on the joystick to left click\n" +
              "\t\t iii. click twice on the joystick to double left click\n" +
              "\t\t vi. click long on the joystick to right click",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),

            SizedBox(
              height: 30.0,
            ),
            Text(
              "\t c. scroll controls have:",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "\t\t i. a joystick to control the scroll",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
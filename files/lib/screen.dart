import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:control_pad/control_pad.dart';


class ScreenPage extends StatefulWidget {
  String codeScanner;
  ScreenPage({this.codeScanner});

  @override
  State<StatefulWidget> createState() => ScreenPageState(codeScanner);
}

class ScreenPageState extends State<ScreenPage> {

  final textController = TextEditingController();
  Socket socket;
  String textData;
  String codeScanner;

  ScreenPageState(this.codeScanner);

   @override
  void initState()
  {
    super.initState();
    initStateHelper();
  }

  void initStateHelper() async
  {
    String ip = codeScanner.split(' ')[0];
    int port = int.parse(codeScanner.split(' ')[1]);
    print('ip ${ip} port ${port}');
    socket = await Socket.connect(ip, port);
    print('connected');
  }

  void sendMsg(String msg)
  {
    socket.write(utf8.encode("${msg}\n"));
    print(msg);
  }

  @override
  Widget build(BuildContext context) {
    JoystickDirectionCallback onDirectionChanged(double degrees, double distance) {
      String data = "mouse_move,${degrees.toStringAsFixed(2)},${distance.toStringAsFixed(2)}";
      sendMsg(data);
    }

    JoystickDirectionCallback onDirectionChanged2(double degrees, double distance) {
      String data = "scroll,${degrees.toStringAsFixed(2)},${distance.toStringAsFixed(2)}";
      sendMsg(data);
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Controller Page"),
        centerTitle: true,
        toolbarHeight: 35,
      ),
       body: GestureDetector(
        onTap: () {FocusScope.of(context).unfocus();}, 
        child:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
                Text('keyboard controls', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center), 
                SizedBox(height: 10.0),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "",
                    labelStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black12
                    ),
                    border: OutlineInputBorder()
                  )
                ),
                Row(children: [
                  FlatButton(child: Text('clear'), onPressed: () => setState(() {
                  textController.text = "";
                }), color: Colors.lightGreen, shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0))),
                
                FlatButton(child: Text('enter'), onPressed: () => setState(() {
                  sendMsg("enter");
                }), color: Colors.lightGreen, shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0))),
                  
                FlatButton(child: Text('send'), onPressed: () => setState(() {
                  sendMsg("keyboard_press:${textController.text}");
                  textController.text = "";
                }), color: Colors.lightGreen, shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0))) ,
                FlatButton(child: Text('erase'), onPressed: () => setState(() {
                  sendMsg("erase");
                }), color: Colors.lightGreen, shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)))  
                ], mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
                SizedBox(height: 30.0),
                Text('mouse controls', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center), 
                SizedBox(height: 10.0),
                GestureDetector(child:JoystickView(onDirectionChanged: onDirectionChanged),
                  onTap: () => {sendMsg("click")}, 
                  onDoubleTap: () => {sendMsg("double_click")},
                  onLongPress: () => {sendMsg("right_click")},
                ),
                SizedBox(height: 30.0),
                Text('scroll controls', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center), 
                SizedBox(height: 10.0),
                JoystickView(onDirectionChanged: onDirectionChanged2)
          ],
        ),
      ),
    ),
    );
  }
}
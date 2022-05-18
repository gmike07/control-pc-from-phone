import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/control_pad.dart';


class ScreenPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScreenPageState();
}

class ScreenPageState extends State<ScreenPage2> {

  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  Socket socket;
  String textData;

  void con() async
  {
    print("${textController1.text}, ${int.parse(textController2.text)}");
    socket = await Socket.connect(textController1.text, int.parse(textController2.text));
    print("success");
    List<int> h = utf8.encode('hello');
    socket.write(utf8.encode('hello'));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Test Page"),
        centerTitle: true
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
                Text('IP', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center), 
                SizedBox(height: 10.0),
                TextField(
                  controller: textController1,
                  decoration: InputDecoration(
                    hintText: "",
                    labelStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black12
                    ),
                    border: OutlineInputBorder()
                  )
                ),
                Text('port', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center), 
                SizedBox(height: 10.0),
                TextField(
                  controller: textController2,
                  decoration: InputDecoration(
                    hintText: "",
                    labelStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black12
                    ),
                    border: OutlineInputBorder()
                  )
                ),
                FlatButton(child: Text('connect'), onPressed: () => setState(() {con();}), 
                      color: Colors.lightGreen, shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)))  
                ],
        ),
      ),
    ),
    );
  }
}
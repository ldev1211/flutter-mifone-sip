import 'package:flutter/material.dart';
import 'package:mifone_sdk_flutter/mifone_sdk.dart';
import 'package:mifone_sdk_flutter/mifone_sdk_flutter.dart';

import 'call_screen/numpad.dart';
import 'call_screen/call_duration.dart';

class NumpadScreen extends StatefulWidget {
  const NumpadScreen({super.key});

  @override
  State<NumpadScreen> createState() => _NumpadScreenState();
}

class _NumpadScreenState extends State<NumpadScreen> {
  final TextEditingController _myController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MifoneSdkFlutter.instance.setConfigureAccount('token');
  }

  Widget buildActon(){
    MifoneSdkFlutter.instance.setEventListener((event) {
      print("DEBUGEVENT: ${event.state}");
      if(event.state == CallStateEnum.PROGRESS){
        print("DEBUGEVENT: ${MifoneSdkFlutter.instance.callDirect()}");
      }
    });
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
      },child: buildActon(),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // display the entered numbers
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 70,
              child: Center(
                  child: TextField(
                    decoration: const InputDecoration.collapsed(hintText: ""),
                controller: _myController,
                textAlign: TextAlign.center,
                showCursor: false,
                style: const TextStyle(fontSize: 30),
              )),
            ),
          ),
          // implement the custom NumPad
          NumPad(
            buttonSize: 50,
            buttonColor: const Color(0xffE5E5E5),
            controller: _myController,
            delete: () {
              if (_myController.text.isNotEmpty) {
                _myController.text = _myController.text
                    .substring(0, _myController.text.length - 1);
              }
            },
            // do something with the input numbers
            onSubmit: () {
              // print("Register state: "+MifoneSdkFlutter.instance.getRegistrationState()!.toString());
              MifoneSdkFlutter.instance.makeCall(_myController.text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DurationCall(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mifone_sdk_flutter/mifone_sdk_flutter.dart';

import 'numpad_duration.dart';

class DurationCall extends StatefulWidget {
  const DurationCall({super.key});

  @override
  State<DurationCall> createState() => _DurationCallState();
}

class _DurationCallState extends State<DurationCall> {
  late DateTime startTime;
  late DateTime currentTime;
  final TextEditingController _myController = TextEditingController();
  late Timer timer = Timer(Duration.zero, () {});

  String timeText = '00:00';
  bool checkConfir = false;
  bool checkEnded = false;

//option call
  bool checkMute = false;
  bool checkSpeaker = false;
  bool checkKeyboard = false;
  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  var check = '';
  checkConfirm() {
    MifoneSdkFlutter.instance.setEventListener(
      (event) {
        setState(() {
          check = event.state.toString();
        });
        print('check----------------------');
        print(check);
        if (check == 'CallStateEnum.CONFIRMED') {
          // bắt máy
          setState(() {
            checkConfir = true;
            startTime = DateTime.now();
            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                currentTime = DateTime.now();
                Duration timeElapsed = currentTime.difference(startTime);
                timeText = formatTime(timeElapsed);
              });
            });
          });
          //không nghe máy ngắt máy
        } else if (check == 'CallStateEnum.ENDED' ||
            check == 'CallStateEnum.FAILED') {
          setState(() {
            checkEnded = true;
            if (checkEnded) return Navigator.pop(context);
          });
        }

        print(
            '----------------------------------- [TEST] ------------------------------------------');
        print(event.state.toString());
      },
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    checkConfirm();
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: sizeScreen.height * 0.1,
              ),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xff5AB873),
                ),
                child: const Center(
                    child: Text(
                  'P',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Calling...',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget optionCall(
      {required Icon icon,
      required String text,
      required VoidCallback onPressed}) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
          iconSize: 35,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.white54),
        )
      ],
    );
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.transparent,
            children: <Widget>[
              NumPadDuration(
                buttonSize: 50,
                buttonColor: const Color(0xffE5E5E5),
                iconColor: Colors.red,
                controller: _myController,
                delete: () {
                  Navigator.of(context).pop();
                },
                onSubmit: () {
                  MifoneSdkFlutter.instance.hangup();
                },
              ),
            ],
          );
        });
  }
}

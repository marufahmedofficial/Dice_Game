import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index1 = 0, index2 = 0, point = 0;
  Random random = Random.secure();
  int sum = 0;
  bool hasGameStarted = false;
  bool isGameRunning = false;
  bool showDice = false;
  String? status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dice Game',
          style: TextStyle(
              color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: hasGameStarted ? gameBody() : startBody(),
      ),
    );
  }

  WillPopScope startBody() {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showCupertinoModalPopup<bool>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: const Text('Do you really want to Exit?',
                  style: TextStyle(fontSize: 18, color: CupertinoColors.black)),
              // message: Text('It\'s a demo for cupertino action sheet.'),
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        exit(0);
                      }
                    },
                    child: Text('OK',
                        style: TextStyle(
                            fontSize: 18, color: Colors.red.shade700)))
              ],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    finish(context);
                  },
                  child: const Text(
                    'Cancel',
                    style:
                        TextStyle(color: CupertinoColors.black, fontSize: 18),
                  )),
            );
          },
        );
        return shouldPop!;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(
              image: AssetImage(
                'images/dice_logo.jpg',
              ),
              height: 200,
              width: 200 ),
          const SizedBox(
            height: 30,
          ),
          const  Text(
            'Welcome to Dice Game',
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),
          ),
          const  SizedBox(
            height: 70,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                hasGameStarted = true;
                isGameRunning = true;
              });
            },
            child: const Text('START'),
          )
        ],
      ),
    );
  }

  Column gameBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (showDice)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                diceList[index1],
                height: 100,
                width: 100,
              ),
              const SizedBox(
                width: 10,
              ),
              Image.asset(
                diceList[index2],
                height: 100,
                width: 100,
              ),
            ],
          ),
        Text(
          'Dice Sum: $sum',
          style: const TextStyle(fontSize: 20,color: Colors.deepPurple),
        ),
        if (point > 0)
          Text(
            'Your Point: $point',
            style: const TextStyle(fontSize: 25,color:Colors.green),
          ),
        if (status != null)
          Text(
            'You $status',
            style: const TextStyle(fontSize: 25),
          ),
        if (isGameRunning)
          ElevatedButton(onPressed: rollTheDice, child: const Text('Roll')),
        if (!isGameRunning)
          ElevatedButton(onPressed: _reset, child: const Text('RESET')),
      ],
    );
  }

  void rollTheDice() {
    setState(() {
      if (!showDice) {
        showDice = true;
      }
      index1 = random.nextInt(6);
      index2 = random.nextInt(6);
      sum = index1 + index2 + 2;
      _checkResult();
    });
  }

  void _reset() {
    setState(() {
      index1 = 0;
      index2 = 0;
      sum = 0;
      point = 0;
      hasGameStarted = false;
      status = null;
    });
  }

  void _checkResult() {
    if (point == 0) {
      if (sum == 7 || sum == 11) {
        status = 'Won';
        //isGameRunning = false;
      } else if (sum == 2 || sum == 3 || sum == 12) {
        status = 'Lost';
        //isGameRunning = false;
      } else {
        point = sum;
      }
    } else {
      if (sum == point) {
        status = 'Won';
        //isGameRunning = false;
      } else if (sum == 7) {
        status = 'Lost';
        //isGameRunning = false;
      }
    }
    if (status != null) isGameRunning = false;
  }
}

final diceList = [
  'images/d1.png',
  'images/d2.png',
  'images/d3.png',
  'images/d4.png',
  'images/d5.png',
  'images/d6.png',
];

void finish(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) Navigator.pop(context, result);
}

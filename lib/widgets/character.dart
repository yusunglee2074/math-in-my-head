import 'package:flutter/material.dart';
import 'package:math_in_my/widgets/game_brain.dart';
import 'package:provider/provider.dart';

class Character extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget answer = SizedBox();
    int displayAnswer = Provider.of<GameBrain>(context).displayAnswer;
    Status status = Provider.of<GameBrain>(context).gameStatus;

    if (displayAnswer != 0 &&
        displayAnswer != null &&
        (status == Status.aiWin || status == Status.playerWin)) {
      answer = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 5.0, color: Colors.white),
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(status == Status.aiWin ? 30.0 : 0),
            bottomRight: Radius.circular(status == Status.playerWin ? 30.0 : 0),
          ),
        ),
        child: Center(
          child: Text(
            displayAnswer.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Image.asset(
            'images/person.png',
            width: 100.0,
            color: Colors.white,
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: answer,
          ),
        ),
        Expanded(
          flex: 1,
          child: Image.asset(
            'images/robot.png',
            width: 80.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

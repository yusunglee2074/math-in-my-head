import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_in_my/widgets/game_brain.dart';
import 'package:provider/provider.dart';

class AnswerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Status status = Provider.of<GameBrain>(context).gameStatus;
    int answer = Provider.of<GameBrain>(context).getAnswer;
    int answerButtonIdx = Random().nextInt(4);
    Widget child;

    if (status == Status.running) {
      child = Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AnsButton((0 + answer - answerButtonIdx).toString()),
                AnsButton((1 + answer - answerButtonIdx).toString()),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AnsButton((2 + answer - answerButtonIdx).toString()),
                AnsButton((3 + answer - answerButtonIdx).toString()),
              ],
            ),
          ),
        ],
      );
    } else if (status == Status.ready) {
      child = Center(child: Text('준비'));
    } else if (status == Status.playerWin) {
      child = Center(child: Text('^_^'));
    } else if (status == Status.aiWin || status == Status.playerWin) {
      child = Center(child: Text('ㅠ_ㅠ'));
    } else if (status == Status.nextLevel || status == Status.retry) {
      child = Container(
        child: Center(
          child: OutlineButton(
            color: Colors.transparent,
            onPressed: () {
              if (status == Status.nextLevel) {
                Provider.of<GameBrain>(context, listen: false).plusGameLevel();
                Provider.of<GameBrain>(context, listen: false).start();
              } else {
                Provider.of<GameBrain>(context, listen: false).start();
              }
            },
            borderSide: BorderSide(
              width: 3.0,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: status == Status.nextLevel ? Text('난이도업') : Text('재시도'),
          ),
        ),
      );
    } else {
      child = Text('이유성.');
    }
    return Expanded(
      child: child,
    );
  }
}

class AnsButton extends StatelessWidget {
  final String text;

  AnsButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            width: 2.0,
            color: Colors.white,
          ),
        ),
        child: FlatButton(
          onPressed: () {
            Provider.of<GameBrain>(context, listen: false).answer(int.parse(text));
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}

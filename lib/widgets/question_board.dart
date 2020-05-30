import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:math_in_my/widgets/game_brain.dart';
import 'package:provider/provider.dart';

class QuestionBoard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.asset(
            'images/board.png',
            fit: BoxFit.fill,
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.05),
            child: (() {
              Status status = Provider.of<GameBrain>(context).gameStatus;
              if (status == Status.ready) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: ReadyText(),
                  ),
                );
              } else if (status == Status.running) {
                return Text(
                  Provider.of<GameBrain>(context).getQuestion,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0,
                  ),
                );
              } else if (status == Status.aiWin) {
                return Text(
                  '패배',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0,
                  ),
                );
              } else if (status == Status.playerWin) {
                return Text(
                  '승리',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0,
                  ),
                );
              } else {
                return Text('계속 도전해보세요.');
              }
            }()),
          ),
        ],
      ),
    );
  }
}

class ReadyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaleAnimatedTextKit(
      text: ["3", "2", "1"],
      textStyle: TextStyle(
        fontSize: 50.0,
      ),
      textAlign: TextAlign.start,
      duration: Duration(milliseconds: 500),
      totalRepeatCount: 1,
    );
  }
}

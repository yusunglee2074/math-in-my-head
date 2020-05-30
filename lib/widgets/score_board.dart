import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_brain.dart';

class ScoreBoard extends StatelessWidget {

  final Map<String, String> description = {
    'win': '잘했어요!',
    'lose': '아까워요!',
    'default': '',
  };

  ScoreBoard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Number(score: Provider.of<GameBrain>(context).getMeScore, me: true),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                ),
              ),
              Number(score: Provider.of<GameBrain>(context).getAiScore, me: false),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 30.0,
            child: Text(
              description[Provider.of<GameBrain>(context).getRoundStatus],
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Number extends StatelessWidget {
  final int score;
  final bool me;

  Number({this.score, this.me});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
        ),
        child: Center(
          child: Text(
            score.toString(),
            style: TextStyle(
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

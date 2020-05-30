import 'package:flutter/material.dart';
import 'package:math_in_my/screens/pause_screen.dart';
import 'package:math_in_my/widgets/answer_button.dart';
import 'package:math_in_my/widgets/character.dart';
import 'package:math_in_my/widgets/game_brain.dart';
import 'package:math_in_my/widgets/question_board.dart';
import 'package:math_in_my/widgets/score_board.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static final id = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<GameBrain>(context, listen: false).start();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<GameBrain>(context, listen: false).pause();
        Navigator.pushNamed(context, PauseScreen.id);
        return false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 10.0,
          ),
          child: Container(
            height: 30.0,
            width: 30.0,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.pause,
                size: 24.0,
                color: Colors.white,
              ),
              elevation: 8,
              onPressed: () {
                Provider.of<GameBrain>(context, listen: false).pause();
                Navigator.pushNamed(context, PauseScreen.id);
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.red[Provider.of<GameBrain>(context).getGameLevel * 100],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  ScoreBoard(),
                  QuestionBoard(),
                  Character(),
                  AnswerButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

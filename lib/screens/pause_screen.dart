import 'package:flutter/material.dart';
import 'package:math_in_my/screens/welcome_screen.dart';
import 'package:math_in_my/widgets/game_brain.dart';
import 'package:provider/provider.dart';

class PauseScreen extends StatelessWidget {
  static String id = '/pause';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 138.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.id));
          },
          child: Icon(
            Icons.home,
            size: 40.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                '현재 난이도 : ${Provider.of<GameBrain>(context).getGameLevel}',
              ),
            ),
            FlatButton(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2.0,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              onPressed: () {
                Provider.of<GameBrain>(context, listen: false).resetGameLevel();
              },
              child: Text('난이도 1로 재설정'),
            ),
            Center(
                child: Text(
                    '상위 ${(1 - (Provider.of<GameBrain>(context).getGameLevel / 20)) * 100} %')),
            Text(
              '단순한 암산이라도 반복하면 뇌가 활성화됩니다.',
              style: TextStyle(fontSize: 17.0),
            ),
            FlatButton(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2.0,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              onPressed: () {
                Provider.of<GameBrain>(context, listen: false).resume();
                Navigator.pop(context);
              },
              child: Text('계속하기'),
            )
          ],
        ),
      ),
    );
  }
}

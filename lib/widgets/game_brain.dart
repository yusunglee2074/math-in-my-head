import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/async.dart';


/*
게임 상태
A. 문제텍스트가 나오는 화면에 3,2,1 시작 을 나타는 상태
B. 타이머가 돌아가고 문제를 맞추는 단계
C. 정답을 공개하고 점수가 반영되고 A 상태로 돌아감
 */
enum Status {
  ready,
  running,
  playerWin,
  aiWin,
  nextLevel, // 레벨업
  retry,
}

class GameBrain extends ChangeNotifier {
  int _meScore = 0;
  int get getMeScore => _meScore;
  int _aiScore = 0;
  int get getAiScore => _aiScore;
  List<Question> _questions = [];
  String get getQuestion => _questions.length != 0 ? _questions.last.text : '';
  int get getAnswer => _questions.length != 0 ? _questions.last.answer : 0;
  int _gameLevel;
  int get getGameLevel => _gameLevel;
  SharedPreferences _prefs;
  CountdownTimer _timer;
  StreamSubscription _sub;
  int displayAnswer;

  Status gameStatus;


  String _roundStatus = 'default';
  String get getRoundStatus => _roundStatus;

  Future<void> init() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    if (_gameLevel == null) {
      _gameLevel = _prefs.getInt('gameLevel') ?? 1;
    }
    createQuestions();
    _meScore = 0;
    _aiScore = 0;
  }

  void start() {
    gameStatus = Status.ready;
    notifyListeners();
    print('3,2,1 카운트 시작!');
    Future.delayed(Duration(seconds: 3), () {
      print('문제낸다!');
      gameStatus = Status.running;
      notifyListeners();
      Question q = _questions.last;
      _timer = CountdownTimer(
        Duration(
          seconds: _gameLevel * 2 + 3,
        ),
        Duration(
          seconds: 1,
        ),
      );
      _sub = _timer.listen(null);
      _sub.onDone(() {
        print('타이머 끝');
        if (!_sub.isPaused) {
          aiWin();
        }
        _sub.cancel();
      });
    });
  }

  void resetGameLevel() async {
    await _prefs.setInt('gameLevel', 1);
    _gameLevel = 1;
    notifyListeners();
    init();
  }

  void pause() {
    print('일시정지');
    _sub.pause();
    _timer.cancel();
  }

  void resume() {
    print('다시시작');
    start();
  }

  void answer(int answer) {
    // 문제의 마지막 것을 보고 정답이면 빼고 타이머 멈춘다음 playerwin
    Question q = _questions.last;
    if (q.answer == answer) {
      playerWin();
      _sub.cancel();
    } else {
      aiWin();
      _sub.cancel();
    }
  }

  void createQuestions() {
    List<Question> questions = [];
    for (var i = 0; i < 5; i++) {
      questions.add(Question(_gameLevel));
    }
    _questions = questions;
  }

  Future<void> plusGameLevel() async {
    await _prefs.setInt('gameLevel', _gameLevel + 1);
    _gameLevel ++;
    notifyListeners();
  }

  Future<void> minusGameLevel() async {
    if (_gameLevel != 1) {
      await _prefs.setInt('gameLevel', _gameLevel - 1);
    }
    notifyListeners();
  }

  void playerWin() async {
    print('플레이어 승리!');
    gameStatus = Status.playerWin;
    displayAnswer = _questions.last.answer;
    _questions.removeLast();
    _roundStatus = 'win';
    _meScore++;

    if (_meScore == 3) {
      await plusGameLevel();
      await init();
      gameStatus = Status.nextLevel;
    } else {
      Future.delayed(Duration(seconds: 3), (){
        gameStatus = Status.ready;
        start();
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void aiWin() async {
    print('ai 승리!');
    gameStatus = Status.aiWin;
    displayAnswer = _questions.last.answer;
    _questions.removeLast();
    _roundStatus = 'lose';
    _aiScore++;

    if (_aiScore == 3) {
      gameStatus = Status.retry;
      await minusGameLevel();
      await init();
    } else {
      Future.delayed(Duration(seconds: 3), (){
        gameStatus = Status.ready;
        start();
        notifyListeners();
      });
    }
    notifyListeners();
  }
}

class Question {
  String text = '';
  int answer;
  int level;

  Question(int level) {
    this.level = level;

    Map<String, Function> math = {
      '+': (a, b) => a + b,
      '-': (a, b) => a - b,
      '*': (a, b) => a * b,
    };

    if (level > 8) {
      bool usePlus = Random().nextBool();
      if (usePlus) {
        int firstInt = Random().nextInt(2) + 1;
        int secondInt = Random().nextInt(10) + 1;
        int thirdInt = Random().nextInt(25) + level * 4;
        text += firstInt.toString();
        text += ' * ';
        text += secondInt.toString();
        text += ' + ';
        text += thirdInt.toString();
        answer = firstInt * secondInt + thirdInt;
      } else {
        int firstInt = Random().nextInt(25) + level * 4;
        int secondInt = Random().nextInt(10) + 1;
        int thirdInt = Random().nextInt(2) + 1;
        text += firstInt.toString();
        text += ' - ';
        text += secondInt.toString();
        text += ' * ';
        text += thirdInt.toString();
        answer = firstInt - secondInt * thirdInt;
      }
    } else if (level > 5) {
      bool usePlus = Random().nextBool();
      int firstInt = Random().nextInt(20) + level * 4;
      int secondInt = Random().nextInt(20) + level * 4;
      int thirdInt = Random().nextInt(20) + level * 4;
      if (usePlus) {
        text += firstInt.toString();
        text += ' + ';
        text += secondInt.toString();
        text += ' - ';
        text += thirdInt.toString();
        answer = firstInt + secondInt - thirdInt;
      } else {
        text += firstInt.toString();
        text += ' - ';
        text += secondInt.toString();
        text += ' + ';
        text += thirdInt.toString();
        answer = firstInt - secondInt + thirdInt;
      }
    } else if (level > 3) {
      bool usePlus = Random().nextBool();
      int firstInt = Random().nextInt(15) + level * 4;
      int secondInt = Random().nextInt(15) + level * 4;
      if (usePlus) {
        text += firstInt.toString();
        text += ' + ';
        text += secondInt.toString();
        answer = firstInt + secondInt;
      } else {
        text += firstInt.toString();
        text += ' - ';
        text += secondInt.toString();
        answer = firstInt - secondInt;
      }
    } else {
      bool usePlus = Random().nextBool();
      int firstInt = Random().nextInt(5) + level * 3;
      int secondInt = Random().nextInt(5) + level * 3;
      if (usePlus) {
        text += firstInt.toString();
        text += ' + ';
        text += secondInt.toString();
        answer = firstInt + secondInt;
      } else {
        text += firstInt.toString();
        text += ' - ';
        text += secondInt.toString();
        answer = firstInt - secondInt;
      }
    }
  }


  /*
  문제 유형
  A + B - C
  A - B + C
  A * B - C
  A * B + C
  A + B * C
  A - B * C
  A * B + C
  A * B + C
  A * B + C
   */





}

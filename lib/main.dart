import 'package:flutter/material.dart';
import 'package:math_in_my/screens/main_screen.dart';
import 'package:math_in_my/screens/pause_screen.dart';
import 'package:math_in_my/screens/welcome_screen.dart';
import 'package:math_in_my/widgets/game_brain.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GameBrain brain;

  @override
  void initState() {
    super.initState();
    brain = GameBrain();
    brain.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) => brain,
      child: MaterialApp(
        title: '암산배틀',
        theme: ThemeData.dark(),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          MainScreen.id: (context) => MainScreen(),
          PauseScreen.id: (context) => PauseScreen(),
        },
      ),
    );
  }
}

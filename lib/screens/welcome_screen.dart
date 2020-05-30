import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:math_in_my/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  static final id = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    animation = ColorTween(begin: Colors.white, end: Colors.yellowAccent).animate(controller);
    controller.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.accessibility),
              onTap: () => print('FIRST CHILD')
          ),
          SpeedDialChild(
            child: Icon(Icons.brush),
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            onTap: () => print('THIRD CHILD'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.wb_incandescent,
                  size: 120.0,
                  color: animation.value,
                ),
                Text(
                  '배틀암산킹',
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
                Text('암산은 뇌 활성에 좋은 활동입니다.'),
                Text('암산킹을 무찌르세요.'),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: MaterialButton(
                    onPressed: () => Navigator.pushNamed(context, MainScreen.id),
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 120.0,
                      color: Colors.red[200],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

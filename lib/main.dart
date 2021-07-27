import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'eventSystem.dart';
import 'game.dart';

final controller = EventController();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]
  ).then((_) {
    runApp(new WitcherApp());
  });
}

class WitcherApp extends StatefulWidget {
  @override
  _WitcherAppState createState() => _WitcherAppState();
}

class _WitcherAppState extends State<WitcherApp> {
  final Game _game = new Game(controller);
  static const String title = 'Witcher';
  String screen = 'Menu';
  Widget screenWidget;

  @override
  Widget build(BuildContext context) {
    streamController();
    screenWidget = loadingScreen();
    switch(screen) {
      case 'Menu': {
          if (_game.menu == null) {
            _game.menuScreen().then((_) {
              setState(() {});
            });
          }
          else {
            if (_game.menu.getLoaded) {
              screenWidget = mainWidget(_game.menu.getScreen);
            }
          }
      }
      break;
      case 'Gameplay': {
          if (_game.gameplay == null) {
            _game.gameplayScreen().then((_) {
              setState(() {});
            });
          }
          else {
            if (_game.gameplay.getLoaded) {
              screenWidget = mainWidget(_game.gameplay.getScreen);
            }
          }
      }
      break;
    }
    return screenWidget;
  }

  streamController() async {
    controller.onEvent.listen((event) {
      screen = event.screen;
      setState(() {});
    });
  }

  Widget loadingScreen() {
    return mainWidget(
        Image.asset('assets/menu/background.png', fit: BoxFit.fill)
    );
  }

  Widget mainWidget(Widget widget, [Color color = const Color(0xff000000)]) {
    return new MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            body: new Container(
                decoration: new BoxDecoration(
                    color: color),
                child: widget
            )
        )
    );
  }
}
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'game_demo.dart';

//PersistantGameState _gameState;

Menu menu = new Menu();
Gameplay gameplay = new Gameplay();

//SoundAssets _sounds;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]
  ).then((_) {
    runApp(new Game());
  });
  //_gameState = new PersistantGameState();
  //await _gameState.load();


//  _sounds = SoundAssets(rootBundle);
//  loads.addAll([
//    _sounds.load(''),
//  ]);

//  await Future.wait(loads);
}

class Game extends StatefulWidget {
  GameState createState() => new GameState();
}

class GameState extends State<Game> {
  GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Title(
          title: 'Witcher',
          color: const Color(0xFF9900FF),
          child: new Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/gameplay':
                    return _buildGameplaySceneRoute();
                  default:
                    return _buildMenuSceneRoute();
                }
              })),
    );
  }

  PageRoute _buildMenuSceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      if (!menu.getLoaded) {
        menu.loadScreen(() {
          Navigator.pushNamed(context, '/menu');
        });
        return _loadingScreen();
      } else {
        return MenuScene();
      }
    });
  }

  PageRoute _buildGameplaySceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      if (!gameplay.getLoaded) {
        gameplay.loadScreen(() {
          Navigator.pushNamed(context, '/gameplay');
        });
        return _loadingScreen();
      } else {
        return GameplayScene(() {
          Navigator.pushNamed(context, '/gameOver');
        });
      }
    });
  }
}

Widget _loadingScreen() {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            body: new Container(
                decoration: new BoxDecoration(color: Color(0xff000000)),
                child: Image.asset('assets/menu/background.png', fit: BoxFit.fill))));
}
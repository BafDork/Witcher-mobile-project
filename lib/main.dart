import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'game.dart';

PersistentGameState _gameState = new PersistentGameState();
Menu menu = new Menu(_gameState);
Gameplay gameplay = new Gameplay(_gameState);

//SoundAssets _sounds;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]
  ).then((_) {
    runApp(new Game());
  });
  //await _gameState.loadState();
  //await _gameState.getManifestMap();

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
      if (!menu.loaded) {
        _loadingGame(context);
        return _loadingScreen();
      } else {
        return MenuScene(_gameState);
      }
    });
  }

  PageRoute _buildGameplaySceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      if (!gameplay.loaded) {
        gameplay.loadScreen(() {
          Navigator.pushNamed(context, '/gameplay');
        });
        return _loadingScreen();
      } else {
        return GameplayScene(_gameState, () {
          Navigator.pushNamed(context, '/endGame');
        });
      }
    });
  }
}

Future<void> _loadingGame(BuildContext context) async {
   await _gameState.getManifestMap(context);
   _gameState.loadState();
   menu.loadScreen(() {
    Navigator.pushNamed(context, '/menu');
  });
}

Widget _loadingScreen() {
  return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(color: Color(0xff000000)),
              child: Image.asset('assets/menu/background.png', fit: BoxFit.fill))));
}
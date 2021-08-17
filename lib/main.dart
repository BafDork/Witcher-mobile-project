import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/widgets.dart';
import 'game.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(new Game());
  });
}

class Game extends StatefulWidget {
  GameState createState() => new GameState();
}

class GameState extends State<Game> with WidgetsBindingObserver {
  GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();
  PersistentGameState _gameState = new PersistentGameState();
  List<AudioPlayer> _players = [];
  Menu _menu;
  Gameplay _gameplay;
  GameEnd _gameEnd;
  bool _landScapeSide = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x > 8 && _landScapeSide) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
        _landScapeSide = false;
      }
      if (event.x < -8 && !_landScapeSide) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
        _landScapeSide = true;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_players.isNotEmpty) {
        for (AudioPlayer player in _players) {
          player.pause();
        }
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (_players.isNotEmpty) {
        for (AudioPlayer player in _players) {
          player.resume();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _menu = new Menu(_gameState);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Title(
          title: 'Witcher',
          color: const Color(0xFF000000),
          child: new Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/endGame':
                    return _buildGameEndSceneRoute();
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
      if (!_menu.loaded) {
        stopSounds();
        _gameEnd = null;
        _loadingGame(context);
        return _loadingScreen();
      } else {
        playSounds(_menu.getSounds());
        _menu.screenWidget = new MenuScene(_gameState, () {
          _gameplay = new Gameplay(_gameState);
          Navigator.pushNamed(context, '/gameplay');
        });
        return _menu.screenWidget;
      }
    });
  }

  PageRoute _buildGameplaySceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      if (!_gameplay.loaded) {
        stopSounds();
        _menu = null;
        _gameplay.loadScreen(() {
          Navigator.pushNamed(context, '/gameplay');
        });
        return _loadingScreen();
      } else {
        playSounds(_gameplay.getSounds());
        _gameplay.screenWidget = new GameplayScene(_gameState, (bool result) {
          _gameEnd = new GameEnd(_gameState, result);
          Navigator.pushNamed(context, '/endGame');
        });
        return _gameplay.screenWidget;
      }
    });
  }

  PageRoute _buildGameEndSceneRoute() {
    return new MaterialPageRoute(builder: (BuildContext context) {
      if (!_gameEnd.loaded) {
        stopSounds();
        _gameplay = null;
        _gameEnd.loadScreen(() {
          Navigator.pushNamed(context, '/endGame');
        });
        return _loadingScreen();
      } else {
        playSounds(_gameEnd.getSounds());
        _gameEnd.screenWidget = GameEndScene(_gameState, () {
          _menu = new Menu(_gameState);
          Navigator.pushNamed(context, '/menu');
        }, _gameEnd.result);
        return _gameEnd.screenWidget;
      }
    });
  }

  Future<void> _loadingGame(BuildContext context) async {
    await _gameState.getManifestMap(context);
    _menu.loadScreen(() {
      Navigator.pushNamed(context, '/menu');
    });
  }

  playSounds(List<String> sounds) async {
    for (String path in sounds) {
      AudioPlayer player = await _gameState.cache.loop(path);
      if (path == 'menu/music.mp3') {
        player.setVolume(0.6);
      }
      _players.add(player);
    }
  }

  stopSounds() {
    if (_players.isNotEmpty) {
      for (AudioPlayer player in _players) {
        player.stop();
      }
      _players.clear();
    }
  }
}

Widget _loadingScreen() {
  return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(color: Color(0xff000000)),
              child: Image.asset('assets/load_screen.png',
                  fit: BoxFit.fill))));
}
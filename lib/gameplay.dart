part of game;

const String _pathGameplay = 'assets/gameplay/';

class Gameplay extends Screen {
  Gameplay(PersistentGameState gameState) : super(gameState);

  @override
  _getAssets() {
    int geraltStatic =
        _gameState.getSpritesCount(_pathGameplay + 'geralt/static');
    int geraltMoving =
        _gameState.getSpritesCount(_pathGameplay + 'geralt/moving');
    int geraltAttack =
        _gameState.getSpritesCount(_pathGameplay + 'geralt/attack');
    int chortStatic =
        _gameState.getSpritesCount(_pathGameplay + 'chort/static');
    int chortMoving =
        _gameState.getSpritesCount(_pathGameplay + 'chort/moving');
    int chortAttack =
        _gameState.getSpritesCount(_pathGameplay + 'chort/attack');
    int background = _gameState.getSpritesCount(_pathGameplay + 'background');
    for (int i = 0;
        i <=
            [
              geraltStatic,
              geraltMoving,
              geraltAttack,
              chortStatic,
              chortMoving,
              chortAttack,
              background
            ].reduce(max);
        i++) {
      if (i < background) {
        _assets.add(_pathGameplay + 'background/frame$i.png');
      }
      if (i < geraltStatic) {
        _assets.add(_pathGameplay + 'geralt/static/frame$i.png');
      }
      if (i < geraltMoving) {
        _assets.add(_pathGameplay + 'geralt/moving/frame$i.png');
      }
      if (i < geraltAttack) {
        _assets.add(_pathGameplay + 'geralt/attack/frame$i.png');
      }
      if (i < chortStatic) {
        _assets.add(_pathGameplay + 'chort/static/frame$i.png');
      }
      if (i < chortMoving) {
        _assets.add(_pathGameplay + 'chort/moving/frame$i.png');
      }
      if (i < chortAttack) {
        _assets.add(_pathGameplay + 'chort/attack/frame$i.png');
      }
    }
  }
}

class GameplayScene extends StatefulWidget {
  final PersistentGameState _gameState;
  final VoidCallback _gameOverCallback;

  GameplayScene(this._gameState, this._gameOverCallback);

  State<GameplayScene> createState() => new GameplaySceneState();
}

class GameplaySceneState extends State<GameplayScene> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    SpritesTreeGameplay _spritesTreeGameplay =
        new SpritesTreeGameplay(widget._gameState);
    return Stack(
      children: <Widget>[
        new SpriteWidget(_spritesTreeGameplay),
        new CustomPaint(painter: DrawHorizontalLine(_spritesTreeGameplay._geralt, _spritesTreeGameplay._chort)),
        new TextureButton(
            onPressed: () {
              _spritesTreeGameplay._geralt._attack._enable = true;
            },
            label: "Attack")
      ],
    );
  }
}

class DrawHorizontalLine extends CustomPainter {
  Paint _paint;
  Geralt _geralt;
  Chort _chort;

  DrawHorizontalLine(this._geralt, this._chort) {
    _paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(30, 30), Offset(_geralt._health * 2, 30), _paint);
    canvas.drawLine(Offset(650 - (_chort._health * 2), 30), Offset(650, 30), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SpritesTreeGameplay extends NodeWithSize {
  final PersistentGameState _gameState;
  GameplaySprites _gameplaySprites;
  Background _background;
  Geralt _geralt;
  Chort _chort;
  VirtualJoystick _joystick = new VirtualStick()._joystick;

  SpritesTreeGameplay(this._gameState) : super(const Size(1920.0, 1080.0)) {
    _gameplaySprites = new GameplaySprites(_gameState);
    _background = new Background(_gameState);
    _geralt = new Geralt(_gameState);
    _chort = new Chort(_gameState);
    _geralt._chort = _chort;
    _chort._geralt = _geralt;
    addChild(_background);
    addChild(_gameplaySprites);
    addChild(_geralt._static);
    addChild(_geralt._moving);
    addChild(_geralt._attack);
    addChild(_chort._static);
    addChild(_chort._moving);
    addChild(_chort._attack);
    addChild(_joystick);
    _geralt._static.runMainMotion();
    _chort._moving.runMainMotion();
  }

  void update(double dt) {
    double scaleX = _joystick.value.dx;
    _chort._update();
    if (!_geralt._completeAttack) {
      return;
    }
    if (_geralt._attack._enable) {
      _geralt.attack();
      return;
    }
    if (_geralt._moving._enable) {
      if (scaleX == 0.0) {
        _geralt._moving.stopMainMotion();
        _geralt._static.runMainMotion();
        _geralt._moving._enable = false;
      } else {
        _geralt._move(scaleX);
      }
    }
    if (!_geralt._moving._enable && scaleX != 0.0) {
      _geralt._static.stopMainMotion();
      _geralt._moving.runMainMotion();
      _geralt._moving._enable = true;
      _geralt._move(scaleX);
    }
  }
}

class VirtualStick extends VirtualJoystick {
  VirtualJoystick _joystick;

  VirtualStick() {
    _joystick = new VirtualJoystick();
    _joystick.position = new Offset(1000.0, 1000.0);
  }
}

class GameplaySprites extends Sprite {
  final PersistentGameState _gameState;

  GameplaySprites(this._gameState);
}

class Background extends SpriteGroup {
  final PersistentGameState _gameState;

  Background(this._gameState)
      : super(_gameState, _pathGameplay + 'background', Offset(1030.0, 540.0),
            3.0, Size(1920.0, 1080.0)) {
    createGroup();
    runMainMotion();
  }
}
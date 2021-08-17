part of game;

class Gameplay extends Screen {
  Gameplay(PersistentGameState gameState) : super(gameState);

  @override
  _getAssets() {
    int geraltStatic =
        _gameState.getSpritesCount(pathGameplay + 'geralt/static');
    int geraltMoving =
        _gameState.getSpritesCount(pathGameplay + 'geralt/moving');
    int geraltAttack =
        _gameState.getSpritesCount(pathGameplay + 'geralt/attack');
    int chortStatic = _gameState.getSpritesCount(pathGameplay + 'chort/static');
    int chortMoving = _gameState.getSpritesCount(pathGameplay + 'chort/moving');
    int chortAttack = _gameState.getSpritesCount(pathGameplay + 'chort/attack');
    int background = _gameState.getSpritesCount(pathGameplay + 'background');
    int sword = _gameState.getSpritesCount(pathGameplay + 'sword');
    List<String> assets = [
      pathGameplay + 'geralt_health.png',
      pathGameplay + 'chort_health.png',
    ];
    int count = [
      geraltStatic,
      geraltMoving,
      geraltAttack,
      chortStatic,
      chortMoving,
      chortAttack,
      background,
      sword
    ].reduce(max);
    for (int i = 0; i <= count; i++) {
      if (i < background) {
        assets.add(pathGameplay + 'background/frame$i.png');
      }
      if (i < sword) {
        assets.add(pathGameplay + 'sword/frame$i.png');
      }
      if (i < geraltStatic) {
        assets.add(pathGameplay + 'geralt/static/frame$i.png');
      }
      if (i < geraltMoving) {
        assets.add(pathGameplay + 'geralt/moving/frame$i.png');
      }
      if (i < geraltAttack) {
        assets.add(pathGameplay + 'geralt/attack/frame$i.png');
      }
      if (i < chortStatic) {
        assets.add(pathGameplay + 'chort/static/frame$i.png');
      }
      if (i < chortMoving) {
        assets.add(pathGameplay + 'chort/moving/frame$i.png');
      }
      if (i < chortAttack) {
        assets.add(pathGameplay + 'chort/attack/frame$i.png');
      }
    }
    return assets;
  }

  @override
  List<String> getSounds() {
    return ['gameplay/music.mp3'];
  }
}

class GameplayScene extends StatefulWidget {
  final PersistentGameState _gameState;
  final GameOverCallBack _switchToGameEnd;

  GameplayScene(this._gameState, this._switchToGameEnd);

  State<GameplayScene> createState() => new GameplaySceneState();
}

class GameplaySceneState extends State<GameplayScene> {
  @override
  Widget build(BuildContext context) {
    SpritesTreeGameplay _spritesTreeGameplay =
        new SpritesTreeGameplay(widget._gameState, widget._switchToGameEnd);
    return Stack(children: <Widget>[
      new SpriteWidget(_spritesTreeGameplay),
      new CustomPaint(
          painter: DrawHorizontalLine(
              _spritesTreeGameplay._geralt, _spritesTreeGameplay._chort))
    ]);
  }
}

class SpritesTreeGameplay extends NodeWithSize {
  VirtualJoystick _joystick = new VirtualJoystick();
  bool _gameOver = false;
  Geralt _geralt;
  Chort _chort;

  SpritesTreeGameplay(PersistentGameState gameState, switchToGameEnd)
      : super(resolution) {
    userInteractionEnabled = true;
    GameOverCallBack gameOverCallBack = (bool result) {
      _gameOver = true;
      switchToGameEnd(result);
    };
    GameplaySprites gameplaySprites = new GameplaySprites(gameState._images);
    SpriteGroup background = new SpriteGroup(gameState, Offset(960, 540), 5)
      ..createGroup(pathGameplay + 'background');
    SpriteGroup sword = new SpriteGroup(gameState, Offset(1650, 880), 1)
      ..createGroup(pathGameplay + 'sword', [0.8, 0.8]);
    _joystick.position = new Offset(300, 1150);
    _joystick.size = new Size(200, 200);
    _joystick.scale = 2;
    _geralt = new Geralt(gameState, gameOverCallBack);
    _chort = new Chort(gameState, gameOverCallBack);
    _geralt._chort = _chort;
    _chort._geralt = _geralt;
    addChild(background);
    addChild(gameplaySprites);
    addChild(_geralt._static);
    addChild(_geralt._moving);
    addChild(_geralt._attack);
    addChild(_chort._static);
    addChild(_chort._moving);
    addChild(_chort._attack);
    addChild(_joystick);
    addChild(sword);
  }

  @override
  void update(double dt) {
    if (_gameOver) {
      return;
    }
    _chort._update();
    if (!_geralt._completeAttack) {
      return;
    }
    if (_geralt._attack._enable) {
      _geralt.attack();
      return;
    }
    double scaleX = _joystick.value.dx;
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

  @override
  bool handleEvent(SpriteBoxEvent event) {
    Offset pointLeftTop = Offset(520, 270);
    Offset pointRightLower = Offset(590, 330);
    if ((event.type is PointerDownEvent) &&
        checkHandleTouch(event.boxPosition, pointLeftTop, pointRightLower)) {
      _geralt._attack._enable = true;
    }
    return super.handleEvent(event);
  }
}

class GameplaySprites extends Sprite {
  GameplaySprites(ImageMap images) {
    Sprite geraltHealth =
        new Sprite.fromImage(images[pathGameplay + 'geralt_health.png'])
          ..position = Offset(450, 140);
    geraltHealth.size = geraltHealth.size * increase;
    Sprite chortHealth =
        new Sprite.fromImage(images[pathGameplay + 'chort_health.png'])
          ..position = Offset(1470, 110);
    chortHealth.size = chortHealth.size * increase;
    addChild(geraltHealth);
    addChild(chortHealth);
  }
}

class DrawHorizontalLine extends CustomPainter {
  Paint _paint;
  Geralt _geralt;
  Chort _chort;

  DrawHorizontalLine(this._geralt, this._chort) {
    _paint = Paint()
      ..strokeWidth = 14
      ..color = Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_geralt._health > 0 && _chort._health > 0) {
      canvas.drawLine(
          Offset(70, 44), Offset(70 + _geralt._health * 2.12, 44), _paint);
      canvas.drawLine(
          Offset(580 - _chort._health * 2.08, 44), Offset(580, 44), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

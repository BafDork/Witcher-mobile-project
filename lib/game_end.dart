part of game;

class GameEnd extends Screen {
  bool _result;

  GameEnd(PersistentGameState gameState, this._result) : super(gameState);

  @override
  _getAssets() {
    int background =
        _gameState.getSpritesCount(pathGameEnd + 'defeat/background/sprites');
    List<String> assets = [
      pathGameEnd + 'menu_title.png',
      pathGameEnd + 'victory/background.png',
      pathGameEnd + 'defeat/title.png',
      pathGameEnd + 'victory/title.png'
    ];
    for (int i = 0; i < background; i++) {
      assets.add(pathGameEnd + 'defeat/background/sprites/frame$i.png');
    }
    return assets;
  }

  @override
  List<String> getSounds() {
    if (_result) {
      return ['game_end/victory/music.mp3'];
    } else {
      return [
        'game_end/defeat/music.mp3',
        'game_end/defeat/background/sound.mp3'
      ];
    }
  }

  bool get result => _result;
}

class GameEndScene extends StatefulWidget {
  final PersistentGameState _gameState;
  final VoidCallback _switchToMenu;
  final bool _result;

  GameEndScene(this._gameState, this._switchToMenu, this._result);

  State<GameEndScene> createState() => new GameEndSceneState();
}

class GameEndSceneState extends State<GameEndScene> {
  @override
  Widget build(BuildContext context) {
    if (widget._result) {
      return new SpriteWidget(new SpritesTreeGameEndVictory(
          widget._gameState, widget._switchToMenu));
    } else {
      return new SpriteWidget(new SpritesTreeGameEndDefeat(
          widget._gameState, widget._switchToMenu));
    }
  }
}

class SpritesTreeGameEndVictory extends NodeWithSize {
  VoidCallback _onPressed;

  SpritesTreeGameEndVictory(PersistentGameState gameState, this._onPressed)
      : super(resolution) {
    userInteractionEnabled = true;
    Sprite background = new Sprite.fromImage(
        gameState._images[pathGameEnd + 'victory/background.png'])
      ..position = Offset(960, 20);
    background.size = background.size * increase;
    Sprite title = new Sprite.fromImage(
        gameState._images[pathGameEnd + 'victory/title.png'])
      ..position = Offset(980, 830);
    title.size = title.size * increase;
    Sprite titleMenu =
        new Sprite.fromImage(gameState._images[pathGameEnd + 'menu_title.png'])
          ..position = Offset(980, 970);
    titleMenu.size = titleMenu.size * increase;
    addChild(background);
    addChild(title);
    addChild(titleMenu);
  }

  @override
  bool handleEvent(SpriteBoxEvent event) {
    Offset pointLeftTop = Offset(295, 310);
    Offset pointRightLower = Offset(395, 340);
    if ((event.type is PointerDownEvent) &&
        checkHandleTouch(event.boxPosition, pointLeftTop, pointRightLower)) {
      _onPressed();
    }
    return super.handleEvent(event);
  }
}

class SpritesTreeGameEndDefeat extends NodeWithSize {
  VoidCallback _onPressed;

  SpritesTreeGameEndDefeat(PersistentGameState gameState, this._onPressed)
      : super(resolution) {
    userInteractionEnabled = true;
    SpriteGroup background = new SpriteGroup(gameState, Offset(960, 540), 5)
      ..createGroup(pathGameEnd + 'defeat/background/sprites', [increase, 1.0546875]);
    Sprite title = new Sprite.fromImage(
        gameState._images[pathGameEnd + 'defeat/title.png'])
      ..position = Offset(1220, 270);
    title.size = title.size * increase;
    Sprite titleMenu =
        new Sprite.fromImage(gameState._images[pathGameEnd + 'menu_title.png'])
          ..position = Offset(1220, 430);
    titleMenu.size = titleMenu.size * increase;
    addChild(background);
    addChild(title);
    addChild(titleMenu);
  }

  @override
  bool handleEvent(SpriteBoxEvent event) {
    Offset pointLeftTop = Offset(370, 127);
    Offset pointRightLower = Offset(470, 160);
    if ((event.type is PointerDownEvent) &&
        checkHandleTouch(event.boxPosition, pointLeftTop, pointRightLower)) {
      _onPressed();
    }
    return super.handleEvent(event);
  }
}

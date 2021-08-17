part of game;

class Menu extends Screen {
  Menu(PersistentGameState gameState) : super(gameState);

  @override
  _getAssets() {
    int geralt = _gameState.getSpritesCount(pathMenu + 'geralt');
    int bonfire = _gameState.getSpritesCount(pathMenu + 'bonfire/sprites');
    int effects = _gameState.getSpritesCount(pathMenu + 'effects');
    List<String> assets = [
      pathMenu + 'name.png',
      pathMenu + 'background.png',
      pathMenu + 'start.png'
    ];
    for (int i = 0; i < [geralt, bonfire, effects].reduce(max); i++) {
      if (i < effects) {
        assets.add(pathMenu + 'effects/frame$i.png');
      }
      if (i < bonfire) {
        assets.add(pathMenu + 'bonfire/sprites/frame$i.png');
      }
      if (i < geralt) {
        assets.add(pathMenu + 'geralt/frame$i.png');
      }
    }
    return assets;
  }

  @override
  List<String> getSounds() {
    return ['menu/music.mp3', 'menu/bonfire/sound.mp3'];
  }
}

class MenuScene extends StatefulWidget {
  final PersistentGameState _gameState;
  final VoidCallback _switchToGameplay;

  MenuScene(this._gameState, this._switchToGameplay);

  State<MenuScene> createState() => new MenuSceneState();
}

class MenuSceneState extends State<MenuScene> {
  Widget build(BuildContext context) {
    return new SpriteWidget(
        new SpritesTreeMenu(widget._gameState, widget._switchToGameplay));
  }
}

class SpritesTreeMenu extends NodeWithSize {
  VoidCallback _onPressed;

  SpritesTreeMenu(PersistentGameState gameState, this._onPressed)
      : super(resolution) {
    userInteractionEnabled = true;
    MenuSprites menuSprites = new MenuSprites(gameState._images);
    SpriteGroup geralt = new SpriteGroup(gameState, Offset(240, 670), 3.2)
      ..createGroup(pathMenu + 'geralt');
    SpriteGroup bonfire = new SpriteGroup(gameState, Offset(565, 770), 0.9)
      ..createGroup(pathMenu + 'bonfire/sprites');
    SpriteGroup effects = new SpriteGroup(gameState, Offset(960, 540), 8)
      ..createGroup(pathMenu + 'effects');
    addChild(menuSprites);
    addChild(bonfire);
    addChild(geralt);
    addChild(effects);
  }

  @override
  bool handleEvent(SpriteBoxEvent event) {
    Offset pointLeftTop = Offset(390, 271);
    Offset pointRightLower = Offset(640, 310);
    if ((event.type is PointerDownEvent) &&
        checkHandleTouch(event.boxPosition, pointLeftTop, pointRightLower)) {
      _onPressed();
    }
    return super.handleEvent(event);
  }
}

class MenuSprites extends Sprite {
  MenuSprites(ImageMap images) {
    Sprite background =
        new Sprite.fromImage(images[pathMenu + 'background.png'])
          ..position = Offset(960, 540);
    background.size = background.size * increase;
    Sprite gameName = new Sprite.fromImage(images[pathMenu + 'name.png'])
      ..position = Offset(1050, 200);
    gameName.size = gameName.size * increase;
    Sprite title = new Sprite.fromImage(images[pathMenu + 'start.png'])
      ..position = Offset(1500, 850);
    title.size = title.size * increase;
    addChild(background);
    addChild(gameName);
    addChild(title);
  }
}

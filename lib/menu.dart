part of game;

const String _pathMenu = 'assets/menu/';

class Menu extends Screen {

  Menu(PersistentGameState gameState) : super(gameState);

  @override _getAssets() {
    int geralt = _gameState.getSpritesCount(_pathMenu + 'geralt');
    int bonfire = _gameState.getSpritesCount(_pathMenu + 'bonfire');
    int effects = _gameState.getSpritesCount(_pathMenu + 'effects');
    _assets.addAll(
        [_pathMenu + 'name.png', _pathMenu + 'background.png', _pathMenu + 'start.png']);
    for (int i = 0; i < [geralt, bonfire, effects].reduce(max); i++) {
      if (i < effects) {
        _assets.add(_pathMenu + 'effects/frame$i.png');
      }
      if (i < bonfire) {
        _assets.add(_pathMenu + 'bonfire/frame$i.png');
      }
      if (i < geralt) {
        _assets.add(_pathMenu + 'geralt/frame$i.png');
      }
    }
  }
}

class MenuScene extends StatefulWidget {
  final PersistentGameState _gameState;

  MenuScene(this._gameState);

  State<MenuScene> createState() => new MenuSceneState();
}

class MenuSceneState extends State<MenuScene> {

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new SpriteWidget(new SpritesTreeMenu(widget._gameState)),
        new SpriteWidget(new StartTitle(widget._gameState)),
        new TextureButton(
            onPressed: () {
              Navigator.pushNamed(context, '/gameplay');
            },
            label: "PLAY")
      ],
    );
  }
}

class StartTitle extends NodeWithSize {
  final PersistentGameState _gameState;
  StartTitleSprite _startTitle;

  StartTitle(this._gameState) : super(const Size(1920.0, 1080.0)) {
    _startTitle = new StartTitleSprite(_gameState._images);
    userInteractionEnabled = true;
    addChild(_startTitle);
  }

  @override
  bool handleEvent(SpriteBoxEvent event) {
//if (event.type == PointerDownEvent) {
//}
    return true;
  }
}

class StartTitleSprite extends Sprite {
  final ImageMap _images;
  Sprite _title;

  StartTitleSprite(this._images) {
    userInteractionEnabled = true;
    _title = new Sprite.fromImage(_images[_pathMenu + 'start.png']);
    _title.position = Offset(500.0, 500.0);
    addChild(_title);
  }
}

class SpritesTreeMenu extends NodeWithSize {
  final PersistentGameState _gameState;
  MenuSprites _menuSprites;
  GeraltMenu _geralt;
  Bonfire _bonfire;
  Effects _effects;

  SpritesTreeMenu(this._gameState) : super(const Size(1920.0, 1080.0)) {
    _menuSprites = new MenuSprites(_gameState._images);
    _geralt = new GeraltMenu(_gameState);
    _bonfire = new Bonfire(_gameState);
    _effects = new Effects(_gameState);
    addChild(_menuSprites);
    addChild(_geralt);
    addChild(_bonfire);
    addChild(_effects);
  }
}

class MenuSprites extends Sprite {
  final ImageMap _images;
  Sprite _background;
  Sprite _name;

  MenuSprites(this._images) {
    _background = new Sprite.fromImage(_images[_pathMenu + 'background.png']);
    _background.position = Offset(1030.0, 540.0);
    _background.size = new Size(1920.0, 1080.0);
    addChild(_background);
    _name = new Sprite.fromImage(_images[_pathMenu + 'name.png']);
    _name.position = Offset(1000.0, 1000.0);
    addChild(_name);
  }
}

class GeraltMenu extends SpriteGroup {

  GeraltMenu(PersistentGameState gameState) : super (gameState, _pathMenu + 'geralt', Offset(500.0, 500.0), 3.0) {
    createGroup();
    runMainMotion();
  }
}

class Bonfire extends SpriteGroup {

  Bonfire(PersistentGameState gameState) : super (gameState, _pathMenu + 'bonfire', Offset(500.0, 500.0), 3.0) {
    createGroup();
    runMainMotion();
  }
}

class Effects extends SpriteGroup {

  Effects(PersistentGameState gameState) : super (gameState, _pathMenu + 'effects', Offset(1030.0, 540.0), 8.0) {
    createGroup();
    runMainMotion();
  }
}
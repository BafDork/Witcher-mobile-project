part of game;

const String _pathMenu = 'assets/menu/';
const int _spritesGeraltNum = 15;
const int _spritesBonfireNum = 8;
const int _spritesEffectsNum = 135;

class Menu extends Screen {

  @override _getAssets() {
    _assets.addAll(
        [_pathMenu + 'name.png', _pathMenu + 'background.png', _pathMenu + 'start.png']);
    for (int i = 0; i <= _spritesEffectsNum; i++) {
      if (i <= _spritesBonfireNum) {
        _assets.add(_pathMenu + 'bonfire/frame$i.png');
      }
      if (i <= _spritesGeraltNum) {
        _assets.add(_pathMenu + 'geralt/frame$i.png');
      }
      _assets.add(_pathMenu + 'effects/frame$i.png');
    }
  }
}

class MenuScene extends StatefulWidget {
  MenuScene(); //this.gameState

//final PersistantGameState gameState;

  State<MenuScene> createState() => new MenuSceneState();
}

class MenuSceneState extends State<MenuScene> {

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new SpriteWidget(new SpritesTreeMenu()),
        new SpriteWidget(new StartTitle()),
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
  StartTitleSprite _startTitle = new StartTitleSprite();

  StartTitle() : super(const Size(1920.0, 1080.0)) {
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
  Sprite _title;

  StartTitleSprite() {
    userInteractionEnabled = true;
    _title = new Sprite.fromImage(_images[_pathMenu + 'start.png']);
    _title.position = Offset(500.0, 500.0);
    addChild(_title);
  }
}

class SpritesTreeMenu extends NodeWithSize {
  MenuSprites _menuSprites = new MenuSprites();
  Geralt _geralt = new Geralt();
  Bonfire _bonfire = new Bonfire();
  Effects _effects = new Effects();

  SpritesTreeMenu() : super(const Size(1920.0, 1080.0)) {
    addChild(_menuSprites);
    addChild(_geralt);
    addChild(_bonfire);
    addChild(_effects);
  }
}

class MenuSprites extends Sprite {
  Sprite _background;
  Sprite _name;

  MenuSprites() {
    _background = new Sprite.fromImage(_images[_pathMenu + 'background.png']);
    _background.position = Offset(1030.0, 540.0);
    _background.size = new Size(1920.0, 1080.0);
    addChild(_background);
    _name = new Sprite.fromImage(_images[_pathMenu + 'name.png']);
    _name.position = Offset(1000.0, 1000.0);
    addChild(_name);
  }
}

class Geralt extends SpriteGroup {
  Geralt() {
    setDuration = 3.0;
    createGroup(_spritesGeraltNum, _pathMenu + 'geralt', Offset(500.0, 500.0));
    motions.run(getMotion);
  }
}

class Bonfire extends SpriteGroup {
  Bonfire() {
    createGroup(_spritesBonfireNum, _pathMenu + 'bonfire', Offset(500.0, 500.0));
    motions.run(getMotion);
  }
}

class Effects extends SpriteGroup {
  Effects() {
    setDuration = 8.0;
    createGroup(_spritesEffectsNum, _pathMenu + 'effects', Offset(1030.0, 540.0),
        Size(1920.0, 1080.0));
    motions.run(getMotion);
  }
}
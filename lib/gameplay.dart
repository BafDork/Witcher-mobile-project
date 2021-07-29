part of game;

const String _pathGameplay = 'assets/gameplay/';
const int _backgroundSpriteNum = 49;
const int _geraltStaticSpritesNum = 15;
const int _geraltMovingSpritesNum =  5;
const int _geraltAttackSpritesNum =  3;
const int _chortStaticSpritesNum = 0;
const int _chortMovingSpritesNum =  6;
const int _chortAttackSpritesNum =  3;

class Gameplay extends Screen {

  @override _getAssets() {
    for (int i = 0; i <= _backgroundSpriteNum; i++) {
      if (i <= _geraltStaticSpritesNum) {
        _assets.add(_pathGameplay + 'geralt/static/frame$i.png');
      }
      if (i <= _geraltMovingSpritesNum) {
        _assets.add(_pathGameplay + 'geralt/moving/frame$i.png');
      }
      if (i <= _geraltAttackSpritesNum) {
        _assets.add(_pathGameplay + 'geralt/attack/frame$i.png');
      }
      if (i <= _chortStaticSpritesNum) {
        _assets.add(_pathGameplay + 'chort/static/frame$i.png');
      }
      if (i <= _chortMovingSpritesNum) {
        _assets.add(_pathGameplay + 'chort/moving/frame$i.png');
      }
      if (i <= _geraltAttackSpritesNum) {
        _assets.add(_pathGameplay + 'chort/attack/frame$i.png');
      }
      _assets.add(_pathGameplay + 'background/frame$i.png');
    }
  }
}

class GameplayScene extends StatefulWidget {
  final VoidCallback gameOverCallback;

  GameplayScene(this.gameOverCallback); //this.gameState

//final PersistantGameState gameState;

  State<GameplayScene> createState() => new GameplaySceneState();
}

class GameplaySceneState extends State<GameplayScene> {

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new SpriteWidget(new SpritesTreeGameplay());
  }
}


class SpritesTreeGameplay extends NodeWithSize {
  GameplaySprites _gameplaySprites = new GameplaySprites();
  Background _background = new Background();
  GeraltStatic _geraltStatic = new GeraltStatic();
  GeraltMoving _geraltMoving = new GeraltMoving();
  GeraltAttack _geraltAttack = new GeraltAttack();
  ChortStatic _chortStatic = new ChortStatic();
  ChortMoving _chortMoving = new ChortMoving();
  ChortAttack _chortAttack = new ChortAttack();
  VirtualJoystick _joystick = new VirtualStick()._joystick;

  SpritesTreeGameplay(): super(const Size(1920.0, 1080.0)) {
    addChild(_background);
    addChild(_gameplaySprites);
    addChild(_geraltStatic);
    addChild(_geraltMoving);
    addChild(_geraltAttack);
    addChild(_chortStatic);
    addChild(_chortMoving);
    addChild(_chortAttack);
    addChild(_joystick);
  }

  void update(double dt) {
    print(_joystick.value);
  }
}

class VirtualStick extends VirtualJoystick {
  VirtualJoystick _joystick;

  VirtualStick() {
    _joystick = new VirtualJoystick();
    _joystick.position = new Offset(1000.0, 1000.0);
  }
}

class GameplaySprites extends Sprite {}

class Background extends SpriteGroup {

  Background() {
    setDuration = 3.0;
    createGroup(_backgroundSpriteNum, _pathGameplay + 'background', Offset(1030.0, 540.0), Size(1920.0, 1080.0));
    motions.run(getMotion);
  }

}

class GeraltStatic extends SpriteGroup {

  GeraltStatic() {
    setDuration = 3.0;
    createGroup(_geraltStaticSpritesNum, _pathGameplay + 'geralt/static', Offset(1030.0, 540.0));
    motions.run(getMotion);
  }

}

class GeraltMoving extends SpriteGroup {

  GeraltMoving() {
    setDuration = 3.0;
    createGroup(_geraltMovingSpritesNum, _pathGameplay + 'geralt/moving', Offset(500.0, 500.0));
  }

}

class GeraltAttack extends SpriteGroup {

  GeraltAttack() {
    setDuration = 3.0;
    createGroup(_geraltAttackSpritesNum, _pathGameplay + 'geralt/attack', Offset(500.0, 500.0));
  }

}

class ChortStatic extends SpriteGroup {

  ChortStatic() {
    setDuration = 3.0;
    createGroup(_chortStaticSpritesNum, _pathGameplay + 'chort/static', Offset(500.0, 500.0));
    motions.run(getMotion);
  }

}

class ChortMoving extends SpriteGroup {

  ChortMoving() {
    setDuration = 3.0;
    createGroup(_chortMovingSpritesNum, _pathGameplay + 'chort/moving', Offset(500.0, 500.0));
  }

}

class ChortAttack extends SpriteGroup {

  ChortAttack() {
    setDuration = 3.0;
    createGroup(_chortAttackSpritesNum, _pathGameplay + 'chort/attack', Offset(500.0, 500.0));
  }

}
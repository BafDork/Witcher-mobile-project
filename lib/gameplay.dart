import 'package:spritewidget/spritewidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:witcher/eventSystem.dart';
import 'screen.dart';


const String _path = 'assets/gameplay/';
const int _backgroundSpriteNum = 49;
const int _geraltStaticSpritesNum = 15;
const int _geraltMovingSpritesNum =  5;
const int _geraltAttackSpritesNum =  3;
const int _chortStaticSpritesNum = 0;
const int _chortMovingSpritesNum =  6;
const int _chortAttackSpritesNum =  3;


class Gameplay extends Screen {
  SpritesTree _spritesTree;
  MovingVirtualStick _movingStick;

  Gameplay( EventController newController ) {
    controller = newController;
    _getAssets();
  }

  Future<Null> build() async {
    await loadAssets();
    _spritesTree = new SpritesTree();
    _movingStick = new MovingVirtualStick();
    setScreen = new Stack(
      children: <Widget>[
        new SpriteWidget(_spritesTree),
        new SpriteWidget(_movingStick)
      ],
    );
    setLoaded = true;
  }

  _getAssets() {
    for (int i = 0; i <= _backgroundSpriteNum; i++) {
      if (i <= _geraltStaticSpritesNum) {
        assets.add(_path + 'geralt/static/frame$i.png');
      }
      if (i <= _geraltMovingSpritesNum) {
        assets.add(_path + 'geralt/moving/frame$i.png');
      }
      if (i <= _geraltAttackSpritesNum) {
        assets.add(_path + 'geralt/attack/frame$i.png');
      }
      if (i <= _chortStaticSpritesNum) {
        assets.add(_path + 'chort/static/frame$i.png');
      }
      if (i <= _chortMovingSpritesNum) {
        assets.add(_path + 'chort/moving/frame$i.png');
      }
      if (i <= _geraltAttackSpritesNum) {
        assets.add(_path + 'chort/attack/frame$i.png');
      }
      assets.add(_path + 'background/frame$i.png');
    }
  }

}

class SpritesTree extends NodeWithSize {
  GameplaySprites _gameplaySprites = new GameplaySprites();
  Background _background = new Background();
  GeraltStatic _geraltStatic = new GeraltStatic();
  GeraltMoving _geraltMoving = new GeraltMoving();
  GeraltAttack _geraltAttack = new GeraltAttack();
  ChortStatic _chortStatic = new ChortStatic();
  ChortMoving _chortMoving = new ChortMoving();
  ChortAttack _chortAttack = new ChortAttack();

  SpritesTree(): super(const Size(1920.0, 1080.0)) {
    addChild(_background);
    addChild(_gameplaySprites);
    addChild(_geraltStatic);
    addChild(_geraltMoving);
    addChild(_geraltAttack);
    addChild(_chortStatic);
    addChild(_chortMoving);
    addChild(_chortAttack);
  }

}

class MovingVirtualStick extends NodeWithSize {
  VirtualJoystick joystick;

  MovingVirtualStick(): super(const Size(1920.0, 1080.0)) {
    joystick = new VirtualJoystick();
    joystick.position = new Offset(1000.0, 1000.0);
    //joystick.userInteractionEnabled = true;
    addChild(joystick);
  }

  @override
  bool handleEvent(SpriteBoxEvent event) {
    print(joystick.value);
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    return true;
  }

}

class GameplaySprites extends Sprite {}

class Background extends SpriteGroup {

  Background() {
    setDuration = 3.0;
    createGroup(_backgroundSpriteNum, _path + 'background', Offset(1030.0, 540.0), Size(1920.0, 1080.0));
    motions.run(getMotion);
  }

}

class GeraltStatic extends SpriteGroup {

  GeraltStatic() {
    setDuration = 3.0;
    createGroup(_geraltStaticSpritesNum, _path + 'geralt/static', Offset(1030.0, 540.0));
    motions.run(getMotion);
  }

}

class GeraltMoving extends SpriteGroup {

  GeraltMoving() {
    setDuration = 3.0;
    createGroup(_geraltMovingSpritesNum, _path + 'geralt/moving', Offset(500.0, 500.0));
  }

}

class GeraltAttack extends SpriteGroup {

  GeraltAttack() {
    setDuration = 3.0;
    createGroup(_geraltAttackSpritesNum, _path + 'geralt/attack', Offset(500.0, 500.0));
  }

}

class ChortStatic extends SpriteGroup {

  ChortStatic() {
    setDuration = 3.0;
    createGroup(_chortStaticSpritesNum, _path + 'chort/static', Offset(500.0, 500.0));
    motions.run(getMotion);
  }

}

class ChortMoving extends SpriteGroup {

  ChortMoving() {
    setDuration = 3.0;
    createGroup(_chortMovingSpritesNum, _path + 'chort/moving', Offset(500.0, 500.0));
  }

}

class ChortAttack extends SpriteGroup {

  ChortAttack() {
    setDuration = 3.0;
    createGroup(_chortAttackSpritesNum, _path + 'chort/attack', Offset(500.0, 500.0));
  }

}
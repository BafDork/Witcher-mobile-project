import 'package:spritewidget/spritewidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:witcher/eventSystem.dart';
import 'screen.dart';


const String _path = 'assets/menu/';
const int _spritesGeraltNum = 15;
const int _spritesBonfireNum =  8;
const int _spritesEffectsNum = 135;


class Menu extends Screen {
  SpritesTree _spritesTree;
  StartTitle _startTitle;

  Menu( EventController newController ) {
    controller = newController;
    _getAssets();
  }

  Future<Null> build() async {
    await loadAssets();
    _spritesTree = new SpritesTree();
    _startTitle = new StartTitle();
    setScreen = new Stack(
      children: <Widget>[
        new SpriteWidget(_spritesTree),
        new SpriteWidget(_startTitle)
      ],
    );
    setLoaded = true;
  }

  _getAssets() {
    assets.addAll([
      _path + 'name.png',
      _path + 'background.png',
      _path + 'start.png'
    ]);
    for (int i = 0; i <= _spritesEffectsNum; i++) {
      if (i <= _spritesBonfireNum) {
        assets.add(_path + 'bonfire/frame$i.png');
      }
      if (i <= _spritesGeraltNum) {
        assets.add(_path + 'geralt/frame$i.png');
      }
      assets.add(_path + 'effects/frame$i.png');
    }
  }
}

class StartTitle extends NodeWithSize {
  StartTitleSprite _startTitle = new StartTitleSprite();

  StartTitle(): super(const Size(1920.0, 1080.0)) {
    userInteractionEnabled = true;
    addChild(_startTitle);
  }

  @override
  bool handleEvent(SpriteBoxEvent event) {
    //if (event.type == PointerDownEvent) {
      controller.action('Gameplay');
    //}
    return true;
  }

}

class StartTitleSprite extends Sprite {
  Sprite _title;

  StartTitleSprite() {
    userInteractionEnabled = true;
    _title = new Sprite.fromImage(images[_path + 'start.png']);
    _title.position = Offset(500.0, 500.0);
    addChild(_title);
  }

}

class SpritesTree extends NodeWithSize {
  MenuSprites _menuSprites = new MenuSprites();
  Geralt _geralt = new Geralt();
  Bonfire _bonfire = new Bonfire();
  Effects _effects = new Effects();

  SpritesTree(): super(const Size(1920.0, 1080.0)) {
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
    _background = new Sprite.fromImage(images[_path + 'background.png']);
    _background.position = Offset(1030.0, 540.0);
    _background.size = new Size(1920.0, 1080.0);
    addChild(_background);
    _name = new Sprite.fromImage(images[_path + 'name.png']);
    _name.position = Offset(1000.0, 1000.0);
    addChild(_name);
  }

}

class Geralt extends SpriteGroup {

  Geralt() {
    setDuration = 3.0;
    createGroup(_spritesGeraltNum, _path + 'geralt', Offset(500.0, 500.0));
    motions.run(getMotion);
  }

}

class Bonfire extends SpriteGroup {

  Bonfire() {
    createGroup(_spritesBonfireNum, _path + 'bonfire', Offset(500.0, 500.0));
    motions.run(getMotion);
  }

}

class Effects extends SpriteGroup {

  Effects() {
    setDuration = 8.0;
    createGroup(_spritesEffectsNum, _path + 'effects', Offset(1030.0, 540.0), Size(1920.0, 1080.0));
    motions.run(getMotion);
  }

}
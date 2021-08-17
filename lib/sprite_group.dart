part of game;

class SpriteGroup extends Sprite {
  PersistentGameState _gameState;
  List<Sprite> _sprites = [];
  bool _repeatForever;
  double _duration;
  Offset _position;
  bool _enable;
  dynamic _motion;

  SpriteGroup(this._gameState, this._position, this._duration, [this._enable = true, this._repeatForever = true]);

  void createGroup(String path,
      [List<double> increase = const [increase, increase]]) {
    int count = _gameState.getSpritesCount(path);
    for (int i = 0; i < count; i++) {
      Sprite sprite =
          new Sprite.fromImage(_gameState._images[path + '/frame$i.png'])
            ..position = _position
            ..visible = false;
      sprite.size = new Size(
          sprite.size.width * increase[0], sprite.size.height * increase[1]);
      _sprites.add(sprite);
      addChild(sprite);
    }
    getMainMotion();
    if (_enable) {
      runMainMotion();
    }
  }

  void changePosition(double x) {
    _position = Offset(_position.dx + x, _position.dy);
    _sprites.forEach((element) {
      element.position = _position;
    });
  }

  void reflectAll(bool enable) {
    _sprites.forEach((element) {
      element.reflect = enable; //////////////////////////////////////////////
    });
  }

  dynamic getMainMotion() {
    _motion = new MotionTween((i) {
      spritesInvisibleAll();
      _sprites[i.toInt()].visible = true;
    }, 0.0, _sprites.length.toDouble() - 1, _duration);
    if (_repeatForever) {
      _motion = new MotionRepeatForever(_motion);
    }
  }

  void runMainMotion() {
    if (!_repeatForever) {
      getMainMotion();
    }
    motions.run(_motion);
  }

  void stopMainMotion() {
    motions.stop(_motion);
    spritesInvisibleAll();
  }

  void spritesInvisibleAll() {
    _sprites.forEach((element) {
      element.visible = false;
    });
  }
}

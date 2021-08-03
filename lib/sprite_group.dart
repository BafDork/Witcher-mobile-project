part of game;

class SpriteGroup extends Sprite {
  final PersistentGameState _gameState;
  MotionRepeatForever _motion;
  List<Sprite> _sprites = [];
  double _duration;
  Offset _position;
  String _path;
  Size _size;

  SpriteGroup(this._gameState, this._path, this._position, this._duration, [this._size]);

  void createGroup() {
    int count = _gameState.getSpritesCount(_path);
    for (int i = 0; i < count; i++) {
      Sprite _sprite = new Sprite.fromImage(_gameState._images[_path + '/frame$i.png']);
      _sprite.position = _position;
      if (_size != null) {
        _sprite.size = _size;
      }
      _sprite.visible = false;
      _sprites.add(_sprite);
      addChild(_sprite);
    }
    _motion = getMainMotion();
  }

  void changePosition(double x) {
    _position = Offset(_position.dx + x, _position.dy);
    _sprites.forEach((element) {
      element.position = _position;
    });
  }

  void reflectAll(bool enable) {
    _sprites.forEach((element) {
      element.reflect = enable;
    });
  }

  MotionRepeatForever getMainMotion() {
    return new MotionRepeatForever(new MotionTween((i) {
      spriteInvisibleAll();
      _sprites[i.toInt()].visible = true;
    }, 0.0, _sprites.length.toDouble() - 1, _duration));
  }

  void runMainMotion() {
    motions.run(_motion);
  }

  void stopMainMotion() {
    motions.stop(_motion);
    spriteInvisibleAll();
  }

  void spriteInvisibleAll() {
    _sprites.forEach((element) {
      element.visible = false;
    });
  }
}
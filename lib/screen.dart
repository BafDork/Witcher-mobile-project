part of game;

ImageMap _images;

abstract class Screen {
  VoidCallback _loadingCallback;
  List<String> _assets = [];
  bool _loaded = false;

  Future<void> loadScreen(VoidCallback loadingCallback) async {
    _loadingCallback = loadingCallback;
    _getAssets();
    await _loadAssets();
    await Future.delayed(Duration(seconds: 3)); // check loading screen working
    await _completingLoad();
  }

  Future<void> _loadAssets() async {
    AssetBundle _bundle = rootBundle;
    _images = new ImageMap(_bundle);
    await _images.load(_assets);
  }

  Future<void> _completingLoad() async {
    _loaded = true;
    _loadingCallback();
  }

  _getAssets() {}

  bool get getLoaded => _loaded;
}

class SpriteGroup extends Sprite {
  List<Sprite> _sprites = [];
  double _duration = 5.0;
  MotionRepeatForever _motion;

  void createGroup(int count, String path, Offset position, [Size size]) {
    for (int i = 0; i <= count; i++) {
      Sprite _sprite = new Sprite.fromImage(_images[path + '/frame$i.png']);
      _sprite.position = position;
      if (size != null) {
        _sprite.size = size;
      }
      _sprite.visible = false;
      _sprites.add(_sprite);
      addChild(_sprite);
    }
    _motion = getMainMotion(_sprites, _duration);
  }

  MotionRepeatForever get getMotion => _motion;

  double get getDuration => _duration;

  set setMotion(MotionRepeatForever value) {
    _motion = value;
  }

  set setDuration(double value) {
    _duration = value;
  }
}

MotionRepeatForever getMainMotion(List<Sprite> list, double duration) {
  return new MotionRepeatForever(new MotionTween((i) {
    spriteInvisibleAll(list);
    list[i.toInt()].visible = true;
  }, 0.0, list.length.toDouble() - 1, duration));
}

void spriteInvisibleAll(List<Sprite> list) {
  list.forEach((element) {
    element.visible = false;
  });
}
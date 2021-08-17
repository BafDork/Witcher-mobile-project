part of game;

abstract class Screen {
  StatefulWidget _screenWidget;
  PersistentGameState _gameState;
  VoidCallback _loadingCallback;
  bool _loaded = false;
  ImageMap _images;

  Screen(this._gameState);

  Future<void> loadScreen(VoidCallback loadingCallback) async {
    _loadingCallback = loadingCallback;
    _loadSounds();
    await _loadAssets();
    await _completingLoad();
  }

  void _loadSounds() {
    _gameState._cache.clearAll();
    List<String> sounds = getSounds();
    _gameState._cache.loadAll(sounds);
  }

  Future<void> _loadAssets() async {
    AssetBundle _bundle = rootBundle;
    _images = new ImageMap(_bundle);
    List<String> assets = _getAssets();
    await _images.load(assets);
  }

  Future<void> _completingLoad() async {
    _gameState._images = _images;
    _loaded = true;
    _loadingCallback();
  }

  List<String> _getAssets() {
    return null;
  }

  List<String> getSounds() {
    return null;
  }

  bool get loaded => _loaded;

  StatefulWidget get screenWidget => _screenWidget;

  set screenWidget(StatefulWidget value) {
    _screenWidget = value;
  }
}

bool checkHandleTouch(
    Offset position, Offset pointLeftTop, Offset pointRightLower) {
  if (position.dx >= pointLeftTop.dx &&
      position.dx <= pointRightLower.dx &&
      position.dy >= pointLeftTop.dy &&
      position.dy <= pointRightLower.dy) {
    return true;
  }
  return false;
}
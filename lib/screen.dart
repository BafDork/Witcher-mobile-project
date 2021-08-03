part of game;

abstract class Screen {
  PersistentGameState _gameState;
  VoidCallback _loadingCallback;
  List<String> _assets = [];
  bool _loaded = false;
  ImageMap _images;

  Screen(PersistentGameState gameState) {
    _gameState = gameState;
  }

  Future<void> loadScreen(VoidCallback loadingCallback) async {
    _loadingCallback = loadingCallback;
    _getAssets();
    await _loadAssets();
    await Future.delayed(Duration(seconds: 1)); // check loading screen working
    await _completingLoad();
  }

  Future<void> _loadAssets() async {
    AssetBundle _bundle = rootBundle;
    _images = new ImageMap(_bundle);
    await _images.load(_assets);
  }

  Future<void> _completingLoad() async {
    _gameState._images = _images;
    _loaded = true;
    _loadingCallback();
  }

  _getAssets() {}

  bool get loaded => _loaded;

  PersistentGameState get gameState => _gameState;
}
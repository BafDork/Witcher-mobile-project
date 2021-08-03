part of game;

class PersistentGameState {

  //int coins = 0;
  ImageMap _images;
  Map<String, dynamic> _manifestMap;

  Future<void> loadState() async {
    String dataDir = (await getApplicationDocumentsDirectory()).path;
    File file = new File(dataDir + '/gamestate.json');
    if (file.existsSync()) {
      print("File exists");
      // String json = file.readAsStringSync();
      // JsonDecoder decoder = new JsonDecoder();
      // Map data = decoder.convert(json);
      //
      // coins = data['coins'];
    }
  }

  // Future saveState() async {
  //   String dataDir = (await getApplicationDocumentsDirectory()).path;
  //   File file = new File(dataDir + '/gamestate.json');
  //   Map data = {
  //     'coins': coins,
  //   };
  //   JsonEncoder encoder = new JsonEncoder();
  //   String json = encoder.convert(data);
  //   file.writeAsStringSync(json);
  // }

  int getSpritesCount(String path) {
    List<String> imagePaths = _manifestMap.keys
        .where((String key) => key.contains(path))
        .toList();
    return imagePaths.length;
  }

  Future<void> getManifestMap(BuildContext context) async {
    String _manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    _manifestMap = json.decode(_manifestContent);
  }
}

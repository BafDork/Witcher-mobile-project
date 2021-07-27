import 'package:spritewidget/spritewidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:witcher/eventSystem.dart';

EventController controller;
ImageMap images;
List<String> assets = [];

abstract class Screen {
  Widget _screen;
  bool _loaded = false;

  Future<Null> loadAssets() async {
    AssetBundle bundle = rootBundle;
    images = new ImageMap(bundle);
    await images.load(assets);
  }

  Widget get getScreen => _screen;

  bool get getLoaded => _loaded;

  set setScreen(Widget value) {
    _screen = value;
  }

  set setLoaded(bool value) {
    _loaded = value;
  }

}

class SpriteGroup extends Sprite {
   List<Sprite> _sprites = [];
   double _duration = 5.0;
   MotionRepeatForever _motion;

   void createGroup(int count, String path, Offset position, [Size size]) {
     for (int i = 0; i <= count; i++) {
       Sprite _sprite = new Sprite.fromImage(images[path + '/frame$i.png']);
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
  return new MotionRepeatForever(
      new MotionTween(
              (i) {
            spriteInvisibleAll(list);
            list[i.toInt()].visible = true;
          },
          0.0,
          list.length.toDouble() - 1,
          duration)
  );
}

void spriteInvisibleAll(List<Sprite> list) {
  list.forEach((element) {
    element.visible = false;
  });
}
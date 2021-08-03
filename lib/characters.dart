part of game;

class Geralt extends Character {
  Chort _chort;

  Geralt(PersistentGameState gameState) : super(gameState) {
    _health = 100.0;
    _step = 10.0;
    _x = 1030.0;
    _static = new Static(_gameState, _pathGameplay + 'geralt/static', Offset(1030.0, 540.0), 3.0);
    _moving = new Dynamic(_gameState, _pathGameplay + 'geralt/moving', Offset(1030.0, 540.0), 3.0);
    _attack = new Dynamic(_gameState, _pathGameplay + 'geralt/attack', Offset(1030.0, 540.0), 1.5);
  }

  void _move(double scale) {
    double newX = _x + scale * _step;
    bool side;
    if (scale >= 0) {
      side = false;
    } else {
      side = true;
    }
    if (_reflect != side) {
      changeSide();
    }
    if (newX >= 113.0 && newX <= 1878) {
      _static.changePosition(scale * _step);
      _moving.changePosition(scale * _step);
      _attack.changePosition(scale * _step);
      _x = newX;
    }
  }

  Future<void> attack() async {
    _attack._enable = false;
    if ((_x - _chort._x).abs() < 150) {
      _chort._health -= 25;
    }
    if (_moving._enable) {
      _moving.stopMainMotion();
      _moving._enable = false;
    } else {
      _static.stopMainMotion();
    }
    _completeAttack = false;
    _attack.runMainMotion();
    await Future.delayed(Duration(milliseconds: 1900));
    await _endingAttack();
  }

  Future<void> _endingAttack() async {
    _attack.stopMainMotion();
    _static.runMainMotion();
    _completeAttack = true;
  }
}

class Chort extends Character {
  Geralt _geralt;

  Chort(PersistentGameState gameState) : super(gameState) {
    _health = 100.0;
    _step = 5.0;
    _x = 500.0;
    _static = new Static(_gameState, _pathGameplay + 'chort/static',
        Offset(500.0, 500.0), 3.0);
    _moving = new Dynamic(_gameState, _pathGameplay + 'chort/moving', Offset(500.0, 500.0), 3.0);
    _attack = new Dynamic(_gameState, _pathGameplay + 'chort/attack', Offset(500.0, 500.0), 3.0);
  }

  Future<void> _update() async {
    if (!_completeAttack) {
      return;
    }
    if ((_x - _geralt._x).abs() > 200) {
      double step = _step;
      bool side;
      if (_x > _geralt._x) {
        side = true;
        step = -_step;
      } else {
        side = false;
      }
      if (_reflect != side) {
        changeSide();
      }
      _static.changePosition(step);
      _moving.changePosition(step);
      _attack.changePosition(step);
      _x += step;
    } else {
        _geralt._health -= 25;
        _moving.stopMainMotion();
        _completeAttack = false;
        _attack.runMainMotion();
        await Future.delayed(Duration(milliseconds: 1900));
        await _endingAttack();
    }
  }

  Future<void> _endingAttack() async {
    _attack.stopMainMotion();
    _moving.runMainMotion();
    _completeAttack = true;
  }
}

abstract class Character {
  PersistentGameState _gameState;
  double _health;
  double _force;
  double _step;
  double _x;
  bool _completeAttack = true;
  bool _reflect = false;
  Static _static;
  Dynamic _moving;
  Dynamic _attack;

  Character(this._gameState);

  void changeSide() {
    _reflect = !_reflect;
    _static.reflectAll(_reflect);
    _moving.reflectAll(_reflect);
    _attack.reflectAll(_reflect);
  }
}

class Static extends SpriteGroup {

  Static(PersistentGameState gameState, String path, Offset position, double duration,
      [Size size])
      : super(gameState, path, position, duration) {
    createGroup();
  }
}

class Dynamic extends SpriteGroup {
  bool _enable = false;

  Dynamic(PersistentGameState gameState, String path, Offset position, double duration,
      [Size size])
      : super(gameState, path, position, duration) {
    createGroup();
  }
}

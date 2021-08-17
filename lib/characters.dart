part of game;

class Geralt extends Character {
  Chort _chort;

  Geralt(PersistentGameState gameState, GameOverCallBack gameOverCallBack)
      : super(gameState, gameOverCallBack) {
    _health = 100;
    _force = 15;
    _step = 5.8;
    _x = 300;
    _static = new SpriteGroup(_gameState, Offset(300, 810), 3)
      ..createGroup(pathGameplay + 'geralt/static');
    _moving = new SpriteGroup(_gameState, Offset(300, 810), 0.7, false)
      ..createGroup(pathGameplay + 'geralt/moving');
    _attack = new SpriteGroup(_gameState, Offset(300, 810), 1, false, false)
      ..createGroup(pathGameplay + 'geralt/attack');
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
    if ((_x - _chort._x).abs() < 295) {
      _chort._health -= _force;
      if (_chort._health <= 0) {
        _gameOverCallback(true);
      }
    }
    if (_moving._enable) {
      _moving.stopMainMotion();
      _moving._enable = false;
    } else {
      _static.stopMainMotion();
    }
    _completeAttack = false;
    _attack.runMainMotion();
    await Future.delayed(Duration(milliseconds: 1500));
    await _endingAttack();
  }

  Future<void> _endingAttack() async {
    _attack.spritesInvisibleAll();
    _static.runMainMotion();
    _completeAttack = true;
  }
}

class Chort extends Character {
  Geralt _geralt;

  Chort(PersistentGameState gameState, GameOverCallBack gameOverCallback)
      : super(gameState, gameOverCallback) {
    _health = 100;
    _force = 25;
    _step = 3;
    _x = 1600;
    _static = new SpriteGroup(_gameState, Offset(1600, 810), 3, false)
      ..createGroup(pathGameplay + 'chort/static');
    _moving = new SpriteGroup(_gameState, Offset(1600, 780), 0.8)
      ..createGroup(pathGameplay + 'chort/moving');
    _attack = new SpriteGroup(_gameState, Offset(1600, 810), 1, false, false)
      ..createGroup(pathGameplay + 'chort/attack');
  }

  Future<void> _update() async {
    if (!_completeAttack) {
      return;
    }
    if ((_x - _geralt._x).abs() > 235) {
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
      _geralt._health -= _force;
      if (_geralt._health <= 0) {
        _gameOverCallback(false);
      }
      _moving.stopMainMotion();
      _completeAttack = false;
      _attack.runMainMotion();
      await Future.delayed(Duration(milliseconds: 4000));
      await _endingAttack();
    }
  }

  Future<void> _endingAttack() async {
    _attack.spritesInvisibleAll();
    _moving.runMainMotion();
    _completeAttack = true;
  }
}

abstract class Character {
  PersistentGameState _gameState;
  GameOverCallBack _gameOverCallback;
  bool _completeAttack = true;
  bool _reflect = false;
  double _health;
  double _force;
  double _step;
  double _x;
  SpriteGroup _static;
  SpriteGroup _moving;
  SpriteGroup _attack;

  Character(this._gameState, this._gameOverCallback);

  void changeSide() {
    _reflect = !_reflect;
    _static.reflectAll(_reflect);
    _moving.reflectAll(_reflect);
    _attack.reflectAll(_reflect);
  }
}

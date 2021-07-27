import 'package:witcher/eventSystem.dart';
import 'package:witcher/gameplay.dart';
import 'menu.dart';

class Game {

    EventController controller;
    Menu menu;
    Gameplay gameplay;

    Game( this.controller );

    Future<Null> menuScreen() async {
        menu = new Menu(controller);
        await menu.build();
    }

    Future<Null> gameplayScreen() async {
        gameplay = new Gameplay(controller);
        await gameplay.build();
    }
}
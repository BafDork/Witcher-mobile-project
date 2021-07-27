import 'dart:async';

class Event {

  final String screen;

  Event( this.screen );
}

class EventController {

  final _eventController = StreamController<Event>();
  Stream<Event> get onEvent => _eventController.stream;

  void action(screen) {
    _eventController.add(Event(screen));
  }
}
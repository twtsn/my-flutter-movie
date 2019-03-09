import 'package:event_bus/event_bus.dart';
EventBus eventBus = new EventBus();
class MyEvent{
  String city;
  String query;
  MyEvent(this.city, this.query);
}
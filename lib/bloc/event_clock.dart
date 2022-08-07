import 'package:equatable/equatable.dart';

abstract class EventClock extends Equatable {
  @override
  List<Object> get props => [];
}

class EventClockEncrementTime extends EventClock {
  int? hour;
  int? minute;

  EventClockEncrementTime({this.hour, this.minute});

  @override
  List<Object> get props => [hour!, minute!];
}

class EventClockDecrementTime extends EventClock {
  int? hour;
  int? minute;

  EventClockDecrementTime({this.hour, this.minute});

  @override
  List<Object> get props => [hour!, minute!];
}

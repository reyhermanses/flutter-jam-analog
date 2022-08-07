import 'package:equatable/equatable.dart';

abstract class StateClock extends Equatable {
  @override
  List<Object> get props => [];
}

class StateClockInit extends StateClock {}

class StateClockMessage extends StateClock {
  String? message;
  StateClockMessage({this.message});
  @override
  List<Object> get props => [message!];
}

class StateClockHourMinuteValue extends StateClock {
  int? hour;
  int? minute;

  StateClockHourMinuteValue({this.hour, this.minute});

  @override
  List<Object> get props => [hour!, minute!];
}

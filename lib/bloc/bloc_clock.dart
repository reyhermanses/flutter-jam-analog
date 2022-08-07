import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_analog/bloc/event_clock.dart';
import 'package:jam_analog/bloc/state_clock.dart';

class BlocClock extends Bloc<EventClock, StateClock> {
  BlocClock() : super(StateClockInit());

  // var hour = DateTime.now().hour;
  // var minute = DateTime.now().minute;

  @override
  Stream<StateClock> mapEventToState(EventClock event) async* {
    if (event is EventClockEncrementTime) {
      var hour = event.hour;
      var minute = event.minute;
      if (minute! > 59) {
        minute = 1;
        // hour = hour + 1;
        // hour = (hour >= 23) ? hour = 0 : hour + 1;
        if (hour! > 24) {
          hour = 1;
        } else {
          hour = hour + 1;
        }
      } else {
        minute = minute + 1;
      }
      // yield StateClockMessage(message: 'incrementTime');
      yield StateClockHourMinuteValue(hour: hour, minute: minute);
    }

    if (event is EventClockDecrementTime) {
      var hour = event.hour;
      var minute = event.minute;

      if (minute! < 1) {
        minute = 60;
        hour = (hour! < 1) ? hour = 24 : hour - 1;
      } else {
        minute = minute - 1;
      }

      yield StateClockHourMinuteValue(hour: hour, minute: minute);
    }
  }
}

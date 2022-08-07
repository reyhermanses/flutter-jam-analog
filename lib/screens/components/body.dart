import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jam_analog/bloc/bloc_clock.dart';
import 'package:jam_analog/bloc/event_clock.dart';
import 'package:jam_analog/bloc/state_clock.dart';
import 'package:jam_analog/models/note.dart';
import 'package:jam_analog/main.dart';
import 'package:jam_analog/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clock.dart';

class Body extends StatefulWidget {
  int? hour;
  int? minute;
  Body({this.hour, this.minute});
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  late final LocalNotificationService service;
  var dateTime = DateTime.now();
  var hour;
  var minute;
  bool isTrue = true;
  String? message;
  Timer? searchOnStoppedTyping;
  BlocClock? _blocClock;

  @override
  void initState() {
    _blocClock = BlocProvider.of<BlocClock>(context);
    service = LocalNotificationService();
    service.initialize();
    listenNotification();
    hour = widget.hour == null ? dateTime.hour : widget.hour;
    minute = widget.minute == null ? dateTime.minute : widget.minute;
    checkPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlocClock, StateClock>(
        builder: (
          context,
          state,
        ) {
          return ListView(
            children: [
              BlocListener<BlocClock, StateClock>(
                listener: (context, state) {
                  if (state is StateClockHourMinuteValue) {
                    setState(() {
                      hour = state.hour;
                      minute = state.minute;
                    });
                  }

                  if (state is StateClockMessage) {
                    print(state.message);
                  }
                },
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) async {
                    if (details.delta.dx > 0) {
                      _blocClock!.add(
                          EventClockEncrementTime(hour: hour, minute: minute));
                      // setState(() {
                      //   // context
                      //   //     .read<BlocClock>()
                      //   //     .add(EventClockEncrementTime());
                      //   // hour = (hour > 23) ? hour = 0 : hour + 1;
                      //   // minute = (minute > 59) ? minute = 1 : minute + 1;

                      //   // if (minute > 59) {
                      //   //   minute = 1;
                      //   //   // hour = hour + 1;
                      //   //   // hour = (hour >= 23) ? hour = 0 : hour + 1;
                      //   //   if (hour > 24) {
                      //   //     hour = 1;
                      //   //   } else {
                      //   //     hour = hour + 1;
                      //   //   }
                      //   // } else {
                      //   //   minute = minute + 1;
                      //   // }
                      // });

                      // if (hour < DateTime.now().hour) {
                      if (hour == DateTime.now().hour &&
                              minute <= DateTime.now().minute ||
                          hour < DateTime.now().hour) {
                        var condition = 'search-not-found';
                        findTime(context, condition);
                      } else {
                        var condition = 'search-found';
                        findTime(context, condition);
                      }
                    } else if (details.delta.dx < 0) {
                      // context.read<BlocClock>().add(EventClockDecrementTime());
                      _blocClock!.add(
                          EventClockDecrementTime(hour: hour, minute: minute));
                      // setState(() {
                      //   // hour = (hour! < 1) ? hour = 24 : hour - 1;
                      //   // minute = (minute < 1) ? minute = 60 : minute - 1;
                      //   if (minute < 1) {
                      //     minute = 60;
                      //     hour = (hour < 1) ? hour = 24 : hour - 1;
                      //   } else {
                      //     minute = minute - 1;
                      //   }
                      // });

                      // if (hour <= DateTime.now().hour) {
                      if (hour == DateTime.now().hour &&
                              minute <= DateTime.now().minute ||
                          hour <= DateTime.now().hour) {
                        var condition = 'search-not-found';
                        findTime(context, condition);
                        // print('error');
                      } else {
                        var condition = 'search-found';
                        findTime(context, condition);
                        // print('success');
                      }
                    }
                  },
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Clock(hour: hour, minute: minute, isTrue: isTrue),
                          isTrue
                              ? Container()
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      isTrue = true;
                                      hour = DateTime.now().hour;
                                      minute = DateTime.now().minute;
                                      removePref();
                                    });
                                    _message(context, 'Clock has been reset !');
                                  },
                                  child: Text('Reset Clock')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void listenNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      // print('payload $payload');

      Note note = Note.fromJsonString(payload);

      print('nilai payload : ${note.hour} : ${note.minute}');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Body(
                    hour: note.hour,
                    minute: note.minute,
                  )));
    }
  }

  findTime(context, condition) {
    // setState(() {
    //   isLoading = true;
    // });
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() {
        searchOnStoppedTyping!.cancel();
        // isLoading = false;
      }); // clear timer
    }
    if (condition == 'search-found') {
      setState(() => searchOnStoppedTyping =
          new Timer(duration, () => searchFound(context)));
    } else {
      setState(() => searchOnStoppedTyping =
          new Timer(duration, () => searchNotFound(context)));
    }
  }

  searchFound(context) async {
    await service.showNotificationWithPayload(
      id: 3,
      title: 'Jam Analog for alarm',
      body: 'Alarm activated on $hour : $minute',
      dateTime: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, (hour == 0) ? 24 : hour, minute),
      second: 4,
      // payload: Note(hour: hour, minute: minute),
      hour: hour,
      minute: minute,
    );
    setState(() {
      isTrue = false;
      message = 'Alarm has been set on $hour:$minute';
    });
    // print(message);
    _message(context, message!);
  }

  searchNotFound(context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.cancel(3);
    // await flutterLocalNotificationsPlugin.cancel(1);

    setState(() {
      message =
          'Can\'t set alarm ! $hour:$minute must be greater than current time ${DateTime.now().hour}:${DateTime.now().minute}';
      isTrue = true;
      hour = DateTime.now().hour;
      minute = DateTime.now().minute;
    });
    _message(context, message!);
  }

  checkPref() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    // print(_pref.getInt("hour"));
    // if (_pref.getInt('hour')! > DateTime.now().hour &&
    //     _pref.getInt('minute')! > DateTime.now().minute) {
    //   setState(() {
    //     isTrue = true;
    //     hour = dateTime.hour;
    //     minute = dateTime.minute;
    //     removePref();
    //   });
    // }
    if (_pref.getInt('hour') == null) {
      setState(() {
        // hour = dateTime.hour;
        // minute = dateTime.minute;
      });
      print('pref kosong');
    } else {
      setState(() {
        // hour = _pref.getInt("hour");
        // minute = _pref.getInt("minute");
        isTrue = false;
      });
      print('pref ada');
    }
  }

  Future removePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("hour");
    await prefs.remove("minute");
  }

  _message(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }
}

void fireAlarm() {
  print('alarm aktif');
}

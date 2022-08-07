import 'dart:async';
import 'dart:math';

import 'package:jam_analog/models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'clock_painter.dart';

class Clock extends StatefulWidget {
  var hour;
  var minute;
  bool isTrue;
  Clock({this.hour, this.minute, required this.isTrue});
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('kiri : ${widget.isTrue}');
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Text('Jam Analog'),
              Text('${widget.hour} : ${widget.minute} : ${_dateTime.second}')
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: kShadowColor.withOpacity(0.20),
                    blurRadius: 75,
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: -pi / 2,
                child: CustomPaint(
                  painter: ClockPainter(context, _dateTime, widget.hour,
                      widget.minute, widget.isTrue),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: 50,
        //   left: 0,
        //   right: 0,
        //   child: Consumer<MyThemeModel>(
        //     builder: (context, theme, child) => GestureDetector(
        //       onTap: () => theme.changeTheme(),
        //       child: SvgPicture.asset(
        //         theme.isLightTheme
        //             ? "assets/icons/Sun.svg"
        //             : "assets/icons/Moon.svg",
        //         height: 24,
        //         width: 24,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

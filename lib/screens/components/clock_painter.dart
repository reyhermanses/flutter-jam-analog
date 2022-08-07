import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jam_analog/services/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPainter extends CustomPainter {
  final BuildContext context;
  final DateTime dateTime;
  final int
      hourDynamic; //variabel ini turunan/inheritance dari class clock digunakan untuk mendapatkan nilai dynamic di saat jarum jam di geser
  final int minute;
  bool
      isTrue; //variable boolean ini turunan/inheritance dari class clock digunakan untuk mem freeze pergerakan jarum jam ketika nilai dari jam yang di geser sudah terbuat.

  ClockPainter(
    this.context,
    this.dateTime,
    this.hourDynamic,
    this.minute,
    this.isTrue,
  );
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);

    double radius = min(centerX, centerY);
    double outerRadius = radius - 20;
    double innerRadius = radius - 30;

    Paint hourDashPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 360; i += 30) {
      double x1 = centerX - outerRadius * cos(i * pi / 180);
      double y1 = centerX - outerRadius * sin(i * pi / 180);

      double x2 = centerX - innerRadius * cos(i * pi / 180);
      double y2 = centerX - innerRadius * sin(i * pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), hourDashPaint);
    }

    // perhitungan menit
    double minX = centerX + size.width * 0.35 * cos((minute * 6) * pi / 180);
    double minY = centerY + size.width * 0.35 * sin((minute * 6) * pi / 180);

    //menit
    canvas.drawLine(
      center,
      Offset(minX, minY),
      Paint()
        ..color = Theme.of(context).colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    // perhitungan jam
    double hourX = centerX +
        size.width *
            0.3 *
            cos((hourDynamic * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourY = centerY +
        size.width *
            0.3 *
            sin((hourDynamic * 30 + dateTime.minute * 0.5) * pi / 180);

    // baris jam
    canvas.drawLine(
      center,
      Offset(hourX, hourY),
      Paint()
        ..color = Theme.of(context).colorScheme.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    // Ket. Baris ini untuk pulse jarum detik
    double secondX =
        centerX + size.width * 0.4 * cos((dateTime.second * 6) * pi / 180);
    double secondY =
        centerY + size.width * 0.4 * sin((dateTime.second * 6) * pi / 180);

    // baris detik
    canvas.drawLine(center, Offset(secondX, secondY),
        Paint()..color = Theme.of(context).errorColor);

    // titik tengah
    Paint dotPainter = Paint()..color = Theme.of(context).colorScheme.shadow;
    canvas.drawCircle(center, 24, dotPainter);
    canvas.drawCircle(
        center, 23, Paint()..color = Theme.of(context).backgroundColor);
    canvas.drawCircle(center, 10, dotPainter);

    if (!isTrue) {
      // logik ini berjalan ketika jarum panjang di geser dan alarm terset otomatis
      setPref(hourDynamic, dateTime.minute);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void setPref(int saveHour, int saveMinute) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setInt("hour", saveHour);
  _prefs.setInt("minute", saveMinute);
  print('pref worked');
}

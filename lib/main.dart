import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jam_analog/bloc/bloc_clock.dart';
import 'package:jam_analog/models/theme_provider.dart';
import 'package:jam_analog/screens/components/body.dart';
import 'package:jam_analog/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => BlocClock()),
      ],
      child: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: Consumer<ThemeProvider>(
            builder: (context, theme, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Jam Analog',
              theme: themeData(context),
              darkTheme: darkThemeData(context),
              themeMode: theme.isLightTheme ? ThemeMode.light : ThemeMode.dark,
              home: Scaffold(
                body: Body(),
              ),
            ),
          )),
    );
  }
}

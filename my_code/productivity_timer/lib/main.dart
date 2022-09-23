import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:productivity_timer/timer_model.dart';
import 'settings.dart';
import 'widgets.dart';
import 'timer.dart';

void main() => runApp(MyApp());

const double defaultPadding = 5.0;
final CountDownTimer timer = CountDownTimer();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timer.startWork();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem<String>> menuItems = [];
    menuItems.add(
      const PopupMenuItem(
        value: 'Settings',
        child: Text('Settings'),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Work Timer'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => menuItems,
            onSelected: (value) {
              if (value == 'Settings') goToSettings(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(
            children: [
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: const Color(0xff009688),
                      text: 'Work',
                      onPressed: () => timer.startWork(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: Color.fromRGBO(96, 125, 139, 1),
                      text: "Short Break",
                      onPressed: () => timer.startBreak(isShort: true),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: const Color(0xff455A64),
                      text: "Long Break",
                      onPressed: () => timer.startBreak(isShort: false),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(defaultPadding))
                ],
              ),
              StreamBuilder(
                stream: timer.stream(),
                builder: (context, AsyncSnapshot snapshot) {
                  TimerModel data =
                      (snapshot.connectionState == ConnectionState.waiting)
                          ? TimerModel('00:00', 1)
                          : snapshot.data;
                  return Expanded(
                    child: CircularPercentIndicator(
                      radius: availableWidth / 3,
                      lineWidth: 10.0,
                      percent: data.percent,
                      center: Text(
                        data.time,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      progressColor: const Color(0xff009688),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      color: const Color(0xff212121),
                      text: 'Stop',
                      onPressed: () => timer.stopTimer(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                  Expanded(
                    child: ProductivityButton(
                      text: 'Restart',
                      color: const Color(0xff099688),
                      onPressed: () => timer.startTimer(),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(defaultPadding)),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }
}

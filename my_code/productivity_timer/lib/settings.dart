import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;
  static const String WORKTIME = 'workTime';
  static const String SHORTBREAK = 'shortBreak';
  static const String LONGBREAK = 'longBreak';
  int? workTime;
  int? shortBreak;
  int? longBreak;
  late SharedPreferences prefs;

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(fontSize: 24);
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Text('Work', style: textStyle),
          const Text(''),
          const Text(''),
          SettingsButton(
            color: const Color(0xff455A64),
            text: '-',
            value: -1,
            setting: WORKTIME,
            callback: updateSettings,
          ),
          TextField(
            controller: txtWork,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(
            color: const Color(0xff009688),
            text: '+',
            value: 1,
            setting: WORKTIME,
            callback: updateSettings,
          ),
          Text(
            'Short',
            style: textStyle,
          ),
          const Text(''),
          const Text(''),
          SettingsButton(
            color: Color(0xff545A64),
            text: '-',
            value: -1,
            setting: SHORTBREAK,
            callback: updateSettings,
          ),
          TextField(
            controller: txtShort,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(
            color: Color(0xff009688),
            text: '+',
            value: 1,
            setting: SHORTBREAK,
            callback: updateSettings,
          ),
          Text(
            'Long',
            style: textStyle,
          ),
          const Text(''),
          const Text(''),
          SettingsButton(
            color: Color(0xff455A64),
            text: '-',
            value: -1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
          TextField(
            controller: txtLong,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(
            color: Color(0xff009688),
            text: '+',
            value: 1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
        ],
      ),
    );
  }

  void readSettings() async {
    prefs = await SharedPreferences.getInstance();
    // read settings and if they're null, set some defaults.
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) prefs.setInt(WORKTIME, 30);
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) prefs.setInt(SHORTBREAK, 5);
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) prefs.setInt(LONGBREAK, 20);
    setState(() {
      txtWork.text = workTime?.toString() ?? '';
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSettings(String key, int value) async {
    prefs = await SharedPreferences.getInstance();
    switch (key) {
      case WORKTIME:
        int workTime = prefs.getInt(WORKTIME)!;
        workTime += value;
        if (workTime >= 1 && workTime <= 180) {
          prefs.setInt(WORKTIME, workTime);
          setState(() {
            txtWork.text = workTime.toString();
          });
        }
        break;

      case SHORTBREAK:
        int shortBreak = prefs.getInt(SHORTBREAK)!;
        shortBreak += value;
        if (shortBreak >= 1 && shortBreak <= 120) {
          prefs.setInt(SHORTBREAK, shortBreak);
          setState(() {
            txtShort.text = shortBreak.toString();
          });
        }
        break;

      case LONGBREAK:
        int longBreak = prefs.getInt(LONGBREAK)!;
        longBreak += value;
        if (longBreak >= 1 && longBreak <= 180) {
          prefs.setInt(LONGBREAK, longBreak);
          setState(() {
            txtLong.text = longBreak.toString();
          });
        }
    }
  }
}

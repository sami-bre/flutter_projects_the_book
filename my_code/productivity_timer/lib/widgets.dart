import 'package:flutter/material.dart';

typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double? size;
  final VoidCallback onPressed;

  ProductivityButton({
    required this.color,
    required this.text,
    required this.onPressed,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      minWidth: size,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;    // 1 or -1
  final String setting;   // 'workTime' or 'shortBreak' ...
  final CallbackSetting callback;

  // ignore: use_key_in_widget_constructors
  const SettingsButton({
    required this.color,
    required this.text,
    required this.value,  
    required this.setting,  
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => callback(setting, value),
      color: color,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

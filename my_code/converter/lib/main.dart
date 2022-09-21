import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  double? _numberFrom;
  String? _startMeasure;
  String? _convertedMeasure;
  String? _resultMessage;

  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];

  final TextStyle inputStyle = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  @override
  void initState() {
    _numberFrom = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Measures Converter'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text('Value', style: labelStyle),
                TextField(
                  style: inputStyle,
                  decoration: const InputDecoration(
                      hintText: 'Please insert the measure to be converted.'),
                  onChanged: ((value) {
                    var rv = double.tryParse(value);
                    if (rv != null) {
                      setState(
                        () {
                          _numberFrom = rv;
                        },
                      );
                    }
                  }),
                ),
                const SizedBox(height: 30),
                Text(
                  'From',
                  style: labelStyle,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _startMeasure,
                  onChanged: (value) {
                    setState(() {
                      _startMeasure = value;
                    });
                  },
                  items: _measures.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: inputStyle,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Text(
                  'To',
                  style: labelStyle,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _convertedMeasure,
                  items: _measures.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: inputStyle,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _convertedMeasure = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  child: Text(
                    'Convert',
                    style: inputStyle,
                  ),
                  onPressed: () {
                    if (_startMeasure == null ||
                        _convertedMeasure == null ||
                        _numberFrom == null) {
                      return;
                    } else {
                      convert(_numberFrom!, _startMeasure!, _convertedMeasure!);
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _resultMessage ?? '',
                  style: labelStyle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void convert(double value, String from, String to) {
    int nFrom = _measuresMap[from]!;
    int nTo = _measuresMap[to]!;
    var multiplier = _formulas[nFrom.toString()][nTo];
    double result = value * multiplier;
    if (result == 0) {
      _resultMessage = 'This conversion can not be performed';
    } else {
      _resultMessage =
          '$_numberFrom $_startMeasure is $result $_convertedMeasure';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }
}

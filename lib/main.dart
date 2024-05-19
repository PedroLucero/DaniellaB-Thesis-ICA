import 'dart:collection';

import 'package:daniella_tesis_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'App Daniella',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              // seedColor: Color.fromARGB(169, 182, 89, 205)),
              seedColor: Color.fromARGB(169, 31, 140, 190)),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _userEmail = '';
  String _password = '';

  TextEditingController get userController => _userController;
  TextEditingController get passwordController => _passwordController;

  // These two are purely for testing purposes
  List<double> testData = [8, 10, 23, 14, 23, 15, 14, 10];
  List<String> testDates = [
    '2024-05-06 20:20:00',
    '2024-05-07 20:20:00',
    '2024-05-08 20:20:00',
    '2024-05-09 20:20:00',
    '2024-05-10 20:20:00',
    '2024-05-11 20:20:00',
    '2024-05-12 20:20:00',
    '2024-05-13 20:20:00',
  ];

  List<GlucoseDayRecord> glucoseRecords = [];
  HashMap testG = HashMap<DateTime, GlucoseDayRecord>();

  MyAppState() {
    // This is an alternate way of saving datapoints. Instead of a List, use a hashmap
    for (var i = 0; i < testDates.length; i++) {
      GlucoseDayRecord currentPoint =
          GlucoseDayRecord(testData[i], DateTime.parse(testDates[i]));
      testG[currentPoint.date] = currentPoint;
    }

    glucoseRecords = List<GlucoseDayRecord>.generate(testDates.length,
        (i) => GlucoseDayRecord(testData[i], DateTime.parse(testDates[i])));
    // I'm worried about this down here :(
    // glucoseRecords[7].addDataPoint(20, DateTime.parse('2024-05-13 20:20:00'));
  }

  void userLogin() {
    _userEmail = _userController.text;
    _password = _passwordController.text;
    _passwordController.text = '';
    print("Login exitoso");
    print(_userEmail);
    print(_password);
    notifyListeners();
  }

  void googlePressed() {
    print("Google Pressed");
    notifyListeners();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// I'm concerned with ordering these values, perhaps a function in appstate to do so...
class GlucoseDayRecord {
  late DateTime date;
  List<double> dataPoints = [];
  // Used to separate distinct dataPoints within DayBriefing
  List<DateTime> hoursMinutes = [];

  GlucoseDayRecord(double firstGlucoseInput, DateTime inDate) {
    date = DateTime(inDate.year, inDate.month, inDate.day);
    hoursMinutes.add(DateTime(date.hour, date.minute));
    dataPoints.add(firstGlucoseInput);
  }

  void addDataPoint(double glucoseValue, DateTime date) {
    dataPoints.add(glucoseValue);
    hoursMinutes.add(DateTime(date.hour, date.minute));
  }

  double getAverageGlucose() {
    var sum = dataPoints.reduce((a, b) => a + b);
    return sum / dataPoints.length;
  }

  String getDay() {
    return date.day.toString();
  }

  String getDate() {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

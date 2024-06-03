import 'dart:ffi';
import 'dart:math';

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
  // These shouldn't be here, rather in login_screen
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _userEmail = '';
  String _password = '';

  TextEditingController get userController => _userController;
  TextEditingController get passwordController => _passwordController;

  // User data
  UserData user = UserData("Pedro Lucero", "pedro@lucero.com", 'Masculino',
      DateTime(2001, 9, 1), "Dr. Doug Thor");

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

  List<GlucoseDayRecord> legGlucoseRecords = [];
  List<DateTime> dates = [];
  double currentTop = 0; // This is to keep the graph nice and inbounds
  List<DateRecordPair> glucoseRecords = [];

  MyAppState() {
    // This is an alternate way of saving datapoints. Instead of a List<a> and List<b>, use a List<pairs>
    currentTop = testData.reduce(max);

    glucoseRecords = List<DateRecordPair>.generate(
        testDates.length,
        (i) => DateRecordPair(
            DateTime.parse(testDates[i]),
            GlucoseDayRecord(
              testData[i],
              DateTime.parse(testDates[i]),
            )));
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

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void updateUserData(String name, String email, String sex, DateTime birthDate,
      String doctor) {
    user.name = name;
    user.email = email;
    user.sex = sex;
    user.birthDate = birthDate;
    user.doctor = doctor;
    notifyListeners();
  }

  void newGlucoseR(double? glucoseVal, DateTime date) {
    for (int i = 0; i < glucoseRecords.length; i++) {
      if (isSameDate(date, glucoseRecords[i].date)) {
        glucoseRecords[i].record.addDataPoint(glucoseVal!, date);
        currentTop =
            max(glucoseRecords[i].record.getAverageGlucose(), currentTop);
        notifyListeners();
        return;
      }
    }
    glucoseRecords
        .add(DateRecordPair(date, GlucoseDayRecord(glucoseVal!, date)));

    currentTop = max(glucoseVal, currentTop);
    glucoseRecords
        .sort((a, b) => a.date.compareTo(b.date)); // Orders dates ascendingly
    notifyListeners();
  }
}

class GlucoseDayRecord {
  late DateTime date;
  List<double> dataPoints = [];
  // Used to separate distinct dataPoints within DayBriefing
  List<DateTime> hoursMinutes = [];

  GlucoseDayRecord(double firstGlucoseInput, DateTime inDate) {
    date = DateTime(inDate.year, inDate.month, inDate.day);
    hoursMinutes.add(DateTime(1, 1, 1, date.hour, date.minute));
    dataPoints.add(firstGlucoseInput);
  }

  void addDataPoint(double glucoseValue, DateTime date) {
    dataPoints.add(glucoseValue);
    if (date.hour == 0 && date.minute == 0 && date.millisecond == 0) {
      return;
    }
    hoursMinutes.add(DateTime(1, 1, 1, date.hour, date.minute));
  }

  double getAverageGlucose() {
    var sum = dataPoints.reduce((a, b) => a + b);
    return sum / dataPoints.length;
  }

  String getDay() {
    return date.day.toString();
  }
}

class DateRecordPair {
  DateTime date;
  GlucoseDayRecord record;

  DateRecordPair(this.date, this.record);
}

class UserData {
  String name;
  String email;
  String sex;
  DateTime birthDate;
  String doctor;

  UserData(this.name, this.email, this.sex, this.birthDate, this.doctor);

  String getBirthDate() {
    return "${birthDate.day}-${birthDate.month}-${birthDate.year}";
  }
}

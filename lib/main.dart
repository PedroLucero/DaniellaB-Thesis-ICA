import 'dart:math';

import 'package:daniella_tesis_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  UserData user = UserData("Daniella Beluche", "daniellab@gmail.com",
      'Femenino', DateTime(2001, 6, 23), "Dr. Patel");

  // These two are purely for testing purposes
  List<double> testData = [98, 100, 123, 114, 123, 115, 114, 80];
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
    // Checking through all the records if the date is already in
    for (int i = 0; i < glucoseRecords.length; i++) {
      // If yes we add into an existing date
      if (isSameDate(date, glucoseRecords[i].date)) {
        glucoseRecords[i].record.addDataPoint(glucoseVal!, date);
        currentTop =
            max(glucoseRecords[i].record.getAverageGlucose(), currentTop);
        notifyListeners();
        return;
      }
    }
    // If not we add a new date
    glucoseRecords
        .add(DateRecordPair(date, GlucoseDayRecord(glucoseVal!, date)));
        for (int i = 0; i < glucoseRecords.length; i++) {
          print(glucoseRecords[i].date);
        }
        

    currentTop = max(glucoseVal, currentTop);
    // Here we order dates... not a .reduce() but a .sort() instead
    // ... duh...
    glucoseRecords
        .sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }
}

class GlucoseDayRecord {
  late DateTime date;
  List<double> dataPoints = [];
  // Used to separate distinct dataPoints within DayBriefing
  List<(int, int)> hoursMinutes = [];

  GlucoseDayRecord(double firstGlucoseInput, DateTime inDate) {
    date = DateTime(inDate.year, inDate.month, inDate.day);
    dataPoints.add(firstGlucoseInput);
    if (inDate.hour == 0 && inDate.minute == 0 && inDate.millisecond == 0) {
      hoursMinutes.add((-1, -1));
      return;
    }
    hoursMinutes.add((inDate.hour, inDate.minute));
  }

  void addDataPoint(double glucoseValue, DateTime date) {
    dataPoints.add(glucoseValue);
    if (date.hour == 0 && date.minute == 0 && date.millisecond == 0) {
      hoursMinutes.add((-1, -1));
      return;
    }
    hoursMinutes.add((date.hour, date.minute));
  }

  double getAverageGlucose() {
    var sum = dataPoints.reduce((a, b) => a + b);
    return sum / dataPoints.length;
  }

  // Used for 'tagging' each bargraph point
  String getDay() {
    return date.day.toString();
  }

  String getHM(int index) {
    if (hoursMinutes[index].$1 == -1 && hoursMinutes[index].$2 == -1) {
      return "Registro número ${index + 1}";
    }
    return "Registro de las ${hoursMinutes[index].$1.toString().padLeft(2, '0')}:${hoursMinutes[index].$2.toString().padLeft(2, '0')}";
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

class PrettyNBbox extends StatelessWidget {
  const PrettyNBbox({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(-1, -1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.black, width: 8),
          left: BorderSide(color: Colors.black, width: 2),
          right: BorderSide(color: Colors.black, width: 8),
        ),
      ),
      child: child,
    );
  }
}

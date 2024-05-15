import 'dart:collection';

import 'package:daniella_tesis_app/input_screen.dart';
import 'package:daniella_tesis_app/test_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  final BuildContext context;
  final glucoseRecord = GraphAppState().glucoseRecords;

  _BarChart(this.context);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: List.generate(
          glucoseRecord.length,
          (i) => makeGroupData(
            i,
            glucoseRecord[i].getAverageGlucose(),
          ),
        ),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: glucoseRecord
                .map((obj) => obj.getAverageGlucose())
                .reduce((a, b) => a > b ? a : b) *
            1.2,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          if (event.runtimeType == FlLongPressStart) {
            // So as to not 'miss tap' into briefing page
            // This mess returns index... somehow...
            var index = barTouchResponse!.spot?.touchedBarGroupIndex;
            if (index != null) {
              // Check if we pressed a bar and not empty space
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DayBriefing(
                        glucoseRecord: glucoseRecord, index: index);
                  });
            }
          }
        },
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                // color: Color.fromARGB(100, 255, 0, 119),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      // color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    var tag = '';
    if (value.toInt() >= 0 && value.toInt() < glucoseRecord.length) {
      tag = glucoseRecord[value.toInt()].getDay();
    }
    Widget text = Text(
      tag,
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: text,
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
              // Acá le ponemos la medida de grid luego ---------------------------------------------------
              showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Color.fromARGB(120, 77, 23, 184),
          Color.fromARGB(120, 255, 0, 221),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: _barsGradient,
          borderRadius: BorderRadius.zero,
          width: 90,
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }
}

class DayBriefing extends StatelessWidget {
  const DayBriefing({
    super.key,
    required this.glucoseRecord,
    required this.index,
  });

  final List<GlucoseDayRecord> glucoseRecord;
  final int index;

  @override
  Widget build(BuildContext context) {
    // This whole section is essentially a NEW screen for the custom daily briefs

    var date = glucoseRecord[index].getDate();

    return FractionallySizedBox(
      heightFactor: 0.89,
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox.shrink(),
          title: Text('Fecha: $date'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Container(
          color: Colors.lightBlue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Resumen del día: '),
                Text(
                    'Nivel de glucosa: ${glucoseRecord[index].getAverageGlucose()}'),
                ElevatedButton(
                  child:
                      Text('Fecha: ${glucoseRecord[index].getDay()} (Cerrar)'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GraphAppState extends ChangeNotifier {
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

  GraphAppState() {
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

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var samples = GraphAppState().glucoseRecords.length;
    var appTitle = "Seguimiento:";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 40,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      drawer: DrawerDirectory(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          appTitle,
          style: titleStyle,
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: Column(children: [
            Text(
              "Niveles de glucosa en sangre",
              style: theme.textTheme.displayMedium!.copyWith(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            // The code held within this SizedBox is sacred. IT WORKS in holding the graph how I wanted
            // it's tedious to change tho.
            SizedBox(
              height: 300, // Height is cool for changing btw
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: SizedBox(
                  width: (samples + (samples / 20)) * 90,
                  child: _BarChart(context),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    print("Boton jajas ${DateTime.now()}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputPage(),
                        ));
                  },
                  child: SizedBox(
                    width: 250,
                    height: 125,
                    child: Center(child: Text("Agregar nivel de glucosa")),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class DrawerDirectory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
              title: Text('Perfil'),
              onTap: () => _navPush(context, TestPage())),
          ListTile(
              title: Text('Comentarios de tu doctor'),
              onTap: () => _navPush(context, TestPage())),
          ListTile(
              title: Text('Agregar nivel de glucosa'),
              onTap: () => _navPush(context, TestPage())),
          ListTile(
              title: Text('Calcular dosis'),
              onTap: () => _navPush(context, TestPage())),
          ListTile(
              title: Text('Nivel de glucosa pendiente por dosis bolus'),
              onTap: () => _navPush(context, TestPage())),
        ],
      ),
    );
  }

  Future<dynamic> _navPush(BuildContext context, Widget page) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ));
  }
}

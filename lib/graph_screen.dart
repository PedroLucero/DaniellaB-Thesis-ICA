import 'package:daniella_tesis_app/comments_screen.dart';
import 'package:daniella_tesis_app/dose_screen.dart';
import 'package:daniella_tesis_app/input_screen.dart';
import 'package:daniella_tesis_app/main.dart';
import 'package:daniella_tesis_app/profile_screen.dart';
import 'package:daniella_tesis_app/test_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _BarChart extends StatelessWidget {
  final BuildContext context;
  final MyAppState appstate;
  // SOMEHOW this line of code spares me from using Consumer<AppState>()
  // THE POWER OF LISTENING BABYYY

  _BarChart(this.context, this.appstate);

  @override
  Widget build(BuildContext context) {
    var glucoseRecord = appstate.glucoseRecords;

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: List.generate(
          glucoseRecord.length,
          (i) => makeGroupData(
            i,
            glucoseRecord[i].record.getAverageGlucose(),
          ),
        ),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: appstate.currentTop * 1.2,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          var glucoseRecord = appstate.glucoseRecords;

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

  Widget getDateTitles(double value, TitleMeta meta) {
    var glucoseRecord = appstate.glucoseRecords;
    final style = TextStyle(
      // color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    var tag = '';
    if (value.toInt() >= 0 && value.toInt() < glucoseRecord.length) {
      tag = glucoseRecord[value.toInt()].record.getDay();
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
            getTitlesWidget: getDateTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(),
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

  final List<DateRecordPair> glucoseRecord;
  final int index;

  @override
  Widget build(BuildContext context) {
    // This whole section is essentially a NEW screen for the custom daily briefs

    var date = DateFormat('dd-MM-yyyy').format(glucoseRecord[index].date);

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
          color: Color.fromARGB(255, 167, 218, 241),
          child: Center(
            child: Consumer<MyAppState>(
              builder: (context, appState, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: List<Widget>.generate(
                      glucoseRecord[index].record.dataPoints.length,
                      (i) => Padding(
                        padding: EdgeInsets.all(10),
                        child: PrettyNBbox(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(glucoseRecord[index].record.getHM(i)),
                                    ElevatedButton(
                                      onPressed: () {
                                        appState.deleteGlucoseR(
                                            glucoseRecord[index].date, i);
                                      },
                                      child: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                Text(
                                    "Valor: ${glucoseRecord[index].record.dataPoints[i]}"),
                                Text(
                                    "Mood: ${glucoseRecord[index].record.moods[i]}"),
                                Text("Comentarios de tu doctor:"),
                                Text(""),
                                ElevatedButton(
                                  child: Text('Cerrar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
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
    var appstate = context.watch<MyAppState>();
    var samples = appstate.glucoseRecords.length;
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
            SizedBox(
              height: 5,
            ),
            Text(
              "Niveles de glucosa en sangre",
              style: theme.textTheme.displayMedium!.copyWith(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 5,
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
                  width: (samples + (samples / 7)) * 90,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: PrettyNBbox(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: _BarChart(context, appstate)),
                    ),
                  ),
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
              onTap: () => _navPush(context, ProfilePage())),
          ListTile(
              title: Text('Comentarios de tu doctor'),
              onTap: () => _navPush(context, CommentsPage())),
          ListTile(
              title: Text('Agregar nivel de glucosa'),
              onTap: () => _navPush(context, InputPage())),
          ListTile(
              title: Text('Calcular dosis'),
              onTap: () => _navPush(context, DosePage())),
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

import 'dart:math';

import 'package:daniella_tesis_app/test_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    var testData = GraphAppState().testData;
    var cols = GraphAppState().dates;

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < cols.length) {
                  return Text(cols[value.toInt()],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ));
                }
                return Text('');
              },
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
        ),
        borderData: borderData,
        barGroups: List.generate(
          testData.length,
          (i) => makeGroupData(
            i,
            testData[i],
          ),
        ),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: testData.reduce(max) * 1.2,
      ),
    );
  }

  int example(a, b) {
    print("Hi");
    return 0;
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          // AYOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
          if (event.runtimeType == FlLongPressStart) {
            print("Hey!");
            var index = barTouchResponse!.spot?.touchedBarGroupIndex;
            if (index != null) {
              print('Long press started on bar index: $index');
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

  // LEGACY FUNCTION
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      // color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    List<String> cols = ['04/', '05', 'W', 'T', 'F', 'S', 'S'];

    Widget text = Text(
      cols[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: text,
    );
  }

  // LEGACY FUNCTION
  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
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

class GraphAppState extends ChangeNotifier {
  List<double> testData = [8, 10, 23, 14, 23, 15, 14, 10, 16, 10];
  List<String> dates = ['04', '05', '06', '07', '08', '09', '10', '11'];

  void exampleplz() {
    // ----------------------------------------------------------------------------------
    print("Ou yea");
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
    var samples = GraphAppState().testData.length;
    var appTitle = "Seguimiento:";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 45,
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
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                // aspectRatio: 1.6,
                // height: 200,
                // width: 300,
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: SizedBox(
                  width: (samples + (samples / 20)) * 90,
                  child: _BarChart(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print("Boton jajas");
              },
              child: Text("Esto funciona :')"),
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
              title: Text('Ejemplo 1'),
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

import 'package:daniella_tesis_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DosePage extends StatefulWidget {
  const DosePage({super.key});

  @override
  State<DosePage> createState() => _DosePageState();
}

class _DosePageState extends State<DosePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appTitle = "Calcula tu dosis Bolus";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text("Cantidad de gramos de carbohidratos"),
                Text("÷"),
                Text("razón de insulina a carbohidratos"),
                SizedBox(
                  height: 10,
                ),
                PrettyNBbox(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          // controller: glucoseVal,
                          decoration: InputDecoration(
                            labelText: "Carbohidratos (gramos)",
                            suffixIcon: Icon(Icons.breakfast_dining),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*$')),
                          ],
                        ),
                        Text("÷"),
                        TextField(
                          // controller: glucoseVal,
                          decoration: InputDecoration(
                            labelText: "Razón insulina a carbohidratos",
                            suffixIcon: Icon(Icons.health_and_safety),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*$')),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: null,
                          child: Text("Calcular"),
                        ),
                      ],
                    ),
                  ),
                ),
                Text("="),
                Text("[   ] Unidades de insulina bolus"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:daniella_tesis_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  var selectedIndex = 0;
  TextEditingController dateinput = TextEditingController();
  DateTime? pickedDate = DateTime.now();
  TextEditingController glucoseVal = TextEditingController();

  @override
  void initState() {
    dateinput.text =
        "Hoy: ${DateFormat('dd-MM-yyyy').format(pickedDate!)}"; //set the initial value of text field
    glucoseVal.text = "100";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var appTitle = "Ingresa datos";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 35,
      fontWeight: FontWeight.w600,
    );

    final firstDate = DateTime(DateTime.now().year - 50);
    final lastDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          appTitle,
          style: titleStyle,
        ),
      ),
      body: Container(
        // height: 300,
        // width: 300,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage("images/ICAlogo.png"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PrettyNBbox(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            // Input for dose date
                            child: TextField(
                              controller: dateinput,
                              decoration: InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText:
                                      "Fecha de la medida" //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    //DateTime.now() - not to allow to choose before today.
                                    firstDate: firstDate,
                                    lastDate: lastDate);

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('dd-mm-yyyy')
                                          .format(pickedDate!);

                                  setState(() {
                                    dateinput.text = formattedDate;
                                    if (appstate.isSameDate(
                                        pickedDate!, DateTime.now())) {
                                      dateinput.text = "Hoy: $formattedDate";
                                    }
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: glucoseVal,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.bloodtype_outlined),
                                  labelText: "Valor de glucosa"),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                // Podría crear el TextInputFormatter custom para mejorar estética...
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*$')),
                                // FilteringTextInputFormatter.deny(','),
                                // FilteringTextInputFormatter.deny('-'),
                                // FilteringTextInputFormatter.deny(' '),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              appstate.newGlucoseR(
                                  double.tryParse(glucoseVal.text),
                                  pickedDate!);
                              print("Boton jajas $pickedDate");
                              Navigator.pop(
                                context,
                              );
                            },
                            child: SizedBox(
                              width: 150,
                              height: 60,
                              child: Center(child: Text("Añadir valor")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

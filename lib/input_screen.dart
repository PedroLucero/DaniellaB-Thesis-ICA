import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  var selectedIndex = 0;
  TextEditingController dateinput = TextEditingController();
  DateTime pickedDate = DateTime.now();

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void initState() {
    dateinput.text =
        "Hoy: ${DateFormat('yyyy-MM-dd').format(pickedDate)}"; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: Column(children: <Widget>[
            Image(
              image: AssetImage("images/ICAlogo.png"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: dateinput,
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Fecha de la medida" //label text of field
                    ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      //DateTime.now() - not to allow to choose before today.
                      firstDate: firstDate,
                      lastDate: lastDate);

                  if (pickedDate != null) {
                    //pickedDate output format => 2021-03-10 00:00:00.000
                    print(pickedDate);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    //formatted date output using intl package =>  2021-03-16
                    print(formattedDate);
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      //set output date to TextField value.
                      dateinput.text = formattedDate;
                      if (isSameDate(pickedDate, DateTime.now())) {
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
                decoration: InputDecoration(
                    icon: Icon(Icons.bloodtype_outlined),
                    labelText: "Valor de glucosa"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  // Podría crear el TextInputFormatter custom para mejorar estética...
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
                  // FilteringTextInputFormatter.deny(','),
                  // FilteringTextInputFormatter.deny('-'),
                  // FilteringTextInputFormatter.deny(' '),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print("Boton jajas ${DateTime.now()}");
                Navigator.pop(
                  context,
                );
              },
              child: SizedBox(
                width: 250,
                height: 125,
                child: Center(child: Text("Añadir valor")),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

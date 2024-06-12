import 'package:daniella_tesis_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userBdate = TextEditingController();
  DateTime? pickedDate;
  TextEditingController userDoctor = TextEditingController();

  @override
  void initState() {
    userName.text = "";
    userEmail.text = "";
    userBdate.text = "";
    userDoctor.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var appTitle = "Mi perfil";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 35,
      fontWeight: FontWeight.w600,
    );

    userName.text = appstate.user.name;
    userEmail.text = appstate.user.email;
    const List<String> sexOptions = <String>['Femenino', 'Masculino'];
    String selectedSex = appstate.user.sex;
    pickedDate = appstate.user.birthDate;
    userBdate.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
    userDoctor.text = appstate.user.doctor;

    final firstDate = DateTime(DateTime.now().year - 100);
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
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Imagen del usuario
                CircleAvatar(
                  radius: 73.0,
                  backgroundColor: Colors.black,
                  child: Container(
                    alignment: Alignment(-0.5, -0.5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://media.licdn.com/dms/image/D4E03AQGxV2wAm4tWsg/profile-displayphoto-shrink_400_400/0/1718155889063?e=1723680000&v=beta&t=3NbjT1mry_n7sSgU2S0sL6TkQ8_9tyOQ5yUlY7GUOrU"),
                      radius: 70.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),

                // tabla de datos
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                  child: PrettyNBbox(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      children: <Widget>[
                        // Nombre
                        TextField(
                          controller: userName,
                          decoration: InputDecoration(
                              labelText: "Nombre",
                              suffixIcon: Icon(Icons.edit)),
                        ),
                        // Correo
                        TextField(
                          controller: userEmail,
                          decoration: InputDecoration(
                              labelText: "Correo",
                              suffixIcon: Icon(Icons.edit)),
                        ),
                        // Fecha de nac.
                        TextField(
                          controller: userBdate,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              labelText: "Fecha de nacimiento"),
                          //set it true, so that user will not able to edit text
                          readOnly: true,
                          onTap: () async {
                            pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: firstDate,
                                lastDate: lastDate);

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate!);
                              userBdate.text = formattedDate;
                              print(userBdate.text);
                            }
                          },
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        // Sexo
                        DropdownMenu<String>(
                          expandedInsets: EdgeInsets.all(0),
                          menuStyle: MenuStyle(),
                          initialSelection: selectedSex,
                          label: Text("Sexo"),
                          onSelected: (String? value) {
                            selectedSex = value!;
                          },
                          dropdownMenuEntries: sexOptions
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                        ),
                        // Doctor que lo atiende
                        TextField(
                          controller: userDoctor,
                          decoration: InputDecoration(
                            labelText: "Doctor que lo atiende",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              appstate.updateUserData(
                                  userName.text,
                                  userEmail.text,
                                  selectedSex,
                                  pickedDate!,
                                  userDoctor.text);
                            },
                            child: Text("Aceptar cambios"))
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

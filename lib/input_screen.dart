import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var checkb = false;
    var appTitle = "ehhh... input";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 35,
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
          child: Column(children: [
            Image(
              image: AssetImage("images/ICAlogo.png"),
            ),
            Row(
              // Acá debe haber una función para stateful widget que
              //deshabilite el date input con respecto al checkbox
              children: [Checkbox(value: checkb, onChanged: null)],
            )
          ]),
        ),
      ),
    );
  }
}

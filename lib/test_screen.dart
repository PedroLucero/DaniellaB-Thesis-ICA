import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appTitle = "TEST:";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 45,
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
        body: Image(image: AssetImage("images/ICAlogo.png")));
  }
}

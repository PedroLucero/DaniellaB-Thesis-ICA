import 'package:daniella_tesis_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<MyAppState>();
    var comments = appstate.doctorComments;
    var appTitle = "Comentarios de tu doctor";
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 25,
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
        color: Color.fromARGB(255, 167, 218, 241),
        child: Center(
          child: Consumer<MyAppState>(
            builder: (context, appState, child) {
              return SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    comments.length,
                    (i) => Padding(
                      padding: EdgeInsets.all(10),
                      child: PrettyNBbox(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Comentario #${i + 1}"),
                              Text(comments[i]),
                              Text(""),
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
    );
  }
}

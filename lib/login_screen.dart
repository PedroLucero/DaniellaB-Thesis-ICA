import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'graph_screen.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = WelcomePage();
    var appTitle = "Login";
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
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Being a stateless Widget means we gotta manually check up
    // God bless this line of code.
    var appState = context.watch<MyAppState>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  ImagenLogin(),
                  InputCorreo(appState: appState),
                  InputPassword(appState: appState),
                  ElevatedButton(
                    // Ingresar
                    onPressed: () {
                      appState.userLogin();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GraphPage()),
                      );
                    },
                    child: Text("Ingresar"),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                appState.googlePressed();
              },
              child: Text("Ya tengo una cuenta"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                appState.googlePressed();
              },
              icon: Icon(Icons.g_mobiledata),
              label: Text("Ingresa con Google"),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagenLogin extends StatelessWidget {
  const ImagenLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: Image(image: AssetImage("images/ICAlogo.png")),
    );
  }
}

class InputCorreo extends StatelessWidget {
  const InputCorreo({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 3.0),
      child: TextField(
        controller: appState.userController,
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 239, 244, 249),
            labelText: "Correo",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)))),
      ),
    );
  }
}

class InputPassword extends StatelessWidget {
  const InputPassword({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 5.0),
      child: TextField(
        controller: appState.passwordController,
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 239, 244, 249),
            labelText: "Contraseña",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            suffixIcon: Icon(Icons.remove_red_eye)),
      ),
    );
  }
}

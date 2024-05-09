import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'graph_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'App Daniella',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              // seedColor: Color.fromARGB(169, 182, 89, 205)),
              seedColor: Color.fromARGB(169, 31, 140, 190)),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _userEmail = '';
  String _password = '';

  void userLogin() {
    _userEmail = _userController.text;
    _password = _passwordController.text;
    _passwordController.text = '';
    print("Login exitoso");
    print(_userEmail);
    print(_password);
    notifyListeners();
  }

  void googlePressed() {
    print("Google Pressed");
    notifyListeners();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    var appState = context.watch<
        MyAppState>(); // Being a stateless Widget means we gotta manually check up
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
        controller: appState._userController,
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
        controller: appState._passwordController,
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

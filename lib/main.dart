import 'package:flutter/material.dart';
import 'package:second_lab_app/register_page.dart';
import 'package:second_lab_app/utility.dart';
import 'package:second_lab_app/configurations.dart';
import 'content_page.dart';
import 'product_view.dart';
import 'todo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Configurations.globalpref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    bool status = Configurations.globalpref.getBool("isLoggedin") ?? false;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: status
          ? const ToDoView()
          : const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _userID = TextEditingController();
  final _password = TextEditingController();

  String? _userIDErrorText;
  String? _passwordErrorText;

  void validate() async {

    setState(() {
      _userIDErrorText = _setUserIDErrorText(_userID.text);
      _passwordErrorText = _setPasswordErrorText(_password.text);
    });

    if (_userIDErrorText != null || _passwordErrorText != null) return;

    bool success = await Utility.loginAPI(
      _userID.text.trim(),
      _password.text.trim(),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ToDoView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Failed')),
      );
    }
  }

  String? _setUserIDErrorText(String value) {
    if (value.isEmpty) return 'Enter email';
    if (!Utility.validateEmail(value)) return 'Invalid email';
    return null;
  }

  String? _setPasswordErrorText(String value) {
    if (value.isEmpty) return 'Enter password';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _userID,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  errorText: _userIDErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _passwordErrorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: validate,
              child: const Text('Login'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Sign Up'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContentPage()),
                );
              },
              child: const Text("content"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductView()),
                );
              },
              child: const Text("products"),
            ),

          ],
        ),
      ),
    );
  }
}
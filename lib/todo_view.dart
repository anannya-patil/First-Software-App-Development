import 'package:flutter/material.dart';
import 'configurations.dart';
import 'main.dart';

class ToDoView extends StatelessWidget {
  const ToDoView({super.key});

  @override
  Widget build(BuildContext context) {

    List<String> todos = [
      "Buy groceries",
      "Go for a walk",
      "Finish homework",
      "Read a book"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Configurations.globalpref.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Login'),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(todos[index]));
        },
      ),
    );
  }
}
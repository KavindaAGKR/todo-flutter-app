import 'package:flutter/material.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/sevices/database_services.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _todoTitle = TextEditingController();
  final TextEditingController _todoDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Add ToDos!",
              style: TextStyle(
                  fontSize: 25, color: Color.fromARGB(255, 26, 10, 93)),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: _todoTitle,
              style: const TextStyle(color: Colors.green),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "title",
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _todoDescription,
              style: const TextStyle(color: Colors.green),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "description",
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  )),
            ),
            ElevatedButton(
                onPressed: () async {
                  await DatabaseServices()
                      .addTodoItem(_todoTitle.text, _todoDescription.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                child: const Text("Add Todo"))
          ],
        ),
      ),
    ));
  }
}

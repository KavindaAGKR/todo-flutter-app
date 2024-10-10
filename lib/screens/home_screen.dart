import 'package:flutter/material.dart';
import 'package:todoapp/models/todo_models.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/sevices/auth_services.dart';
import 'package:todoapp/sevices/database_services.dart';
import 'package:todoapp/widgets/completed_widgets.dart';
import 'package:todoapp/widgets/pending_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final AuthService _auth = AuthService();

  int _buttonIndex = 0;

  final _widgets = [const PendingWidgets(), const CompletedWidgets()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          "Todo Home Screen",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () async {
                // await _auth.signOut();
                await AuthService().signOut();
                // ignore: use_build_context_synchronously
                //Navigator.pushReplacement(context,
                //    MaterialPageRoute(builder: (context) => LoginScreen()));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              label: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _buttonIndex = 0;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(
                          color:
                              _buttonIndex == 0 ? Colors.indigo : Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Pending",
                          style: TextStyle(
                            fontSize: _buttonIndex == 0 ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color:
                                _buttonIndex == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _buttonIndex = 1;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          color:
                              _buttonIndex == 1 ? Colors.indigo : Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: _buttonIndex == 1 ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color:
                                _buttonIndex == 1 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _widgets[_buttonIndex],
              // ElevatedButton.icon(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const AddTodo()));
              //     },
              //     label: Icon(Icons.add)),
              // SizedBox(
              //   height: 50,
              // ),
              // _buttonIndex == 0 ? PendingWidgets() : CompletedWidgets()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () {
            _showTaskDialog(context);
          }),
    );
  }

  void _showTaskDialog(BuildContext context, {Todo? todo}) {
    final TextEditingController _titleController =
        TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: todo?.description);
    final DatabaseServices _databaseServices = DatabaseServices();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              todo == null ? "Add task" : "Edit task",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.green),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white60)),
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
                      controller: _descriptionController,
                      style: const TextStyle(color: Colors.green),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white60)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "description",
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    if (todo == null) {
                      await _databaseServices.addTodoItem(
                          _titleController.text, _descriptionController.text);
                    } else {
                      await _databaseServices.updateTodo(todo.id,
                          _titleController.text, _descriptionController.text);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: Text(todo == null ? "Add" : "Update"))
            ],
          );
        });
  }
}

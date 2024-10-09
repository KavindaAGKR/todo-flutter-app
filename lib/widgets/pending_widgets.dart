import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/models/todo_models.dart';
import 'package:todoapp/sevices/database_services.dart';

class PendingWidgets extends StatefulWidget {
  const PendingWidgets({super.key});

  @override
  State<PendingWidgets> createState() => _PendingWidgetsState();
}

class _PendingWidgetsState extends State<PendingWidgets> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
        stream: _databaseServices.pendingTodos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Todo> todos = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                final DateTime dt = todo.timeStamp.toDate();
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 253, 253),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Slidable(
                      key: ValueKey(todo.id),
                      endActionPane:
                          ActionPane(motion: DrawerMotion(), children: [
                        SlidableAction(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.done,
                            onPressed: (context) async {
                              await _databaseServices.updateTodoStatus(
                                  todo.id, true);
                            })
                      ]),
                      startActionPane:
                          ActionPane(motion: DrawerMotion(), children: [
                        SlidableAction(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            onPressed: (context) {
                              _showTaskDialog(context);
                            }),
                        SlidableAction(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            onPressed: (context) async {
                              await _databaseServices.deleteTodoTask(todo.id);
                            })
                      ]),
                      child: ListTile(
                        title: Text(
                          todo.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(todo.description),
                        trailing: Text(
                          "${dt.day}/${dt.month}/${dt.year}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        });
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
                    Navigator.pop(context);
                  },
                  child: Text(todo == null ? "Add" : "Update"))
            ],
          );
        });
  }
}

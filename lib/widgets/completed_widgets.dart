import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/models/todo_models.dart';
import 'package:todoapp/sevices/database_services.dart';

class CompletedWidgets extends StatefulWidget {
  const CompletedWidgets({super.key});

  @override
  State<CompletedWidgets> createState() => _CompletedWidgetsState();
}

class _CompletedWidgetsState extends State<CompletedWidgets> {
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
    return StreamBuilder(
        stream: _databaseServices.completedTodos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Todo> completeTodos = snapshot.data!;
            return Container(
                child: Center(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: completeTodos.length,
                  itemBuilder: (context, index) {
                    Todo todo = snapshot.data![index];
                    final DateTime date = todo.timeStamp.toDate();

                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 101, 230, 153),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Slidable(
                          key: ValueKey(todo.id),
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: Colors.red,
                                    borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(20)),
                                    icon: Icons.delete,
                                    onPressed: (context) async {
                                      await _databaseServices
                                          .deleteTodoTask(todo.id);
                                    }),
                                SlidableAction(
                                    icon: Icons.edit,
                                    backgroundColor: Colors.yellow,
                                    onPressed: (context) {
                                      _showTaskDialog(context, todo: todo);
                                    })
                              ]),
                          endActionPane:
                              ActionPane(motion: DrawerMotion(), children: [
                            SlidableAction(
                                //icon: Icons.done,
                                label: "Move to pending",
                                backgroundColor: Colors.green,
                                onPressed: (context) async {
                                  await _databaseServices.updateTodoStatus(
                                      todo.id, false);
                                }),
                          ]),
                          child: ListTile(
                            title: Text(
                              todo.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(todo.description),
                            trailing:
                                Text("${date.day}/${date.month}/${date.year}"),
                          )),
                    );
                  }),
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
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

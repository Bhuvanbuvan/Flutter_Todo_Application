import 'package:flutter/material.dart';
import 'package:newproject/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController et = TextEditingController();

  Database? _database;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'task_database_db'),
            onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT)",
      );
    }, version: 1);

    _fetchTasks(); // Fetch tasks after initializing the database
  }

  Future<void> _insert(String title) async {
    if (_database != null) {
      final task = Todo(title: title);
      await _database!.insert('task', task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Fetch all tasks from the database
  Future<void> _fetchTasks() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps = await _database!.query('task');

      setState(() {
        todos = List.generate(maps.length, (i) {
          return Todo.fromMap(maps[i]);
        });
      });
    }
  }

  Future<void> _addTask(BuildContext context) async {
    final title = et.text;
    if (title.isNotEmpty) {
      await _insert(title);
      _fetchTasks(); // Fetch tasks after inserting a new task
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Task Added $title"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter a value"),
        ),
      );
    }
  }

  @override
  void dispose() {
    et.dispose();
    super.dispose();
  }

  int position = 0;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black, width: 2),
    );

    Widget buttonWidget(int op, {required String text}) {
      return TextButton(
        onPressed: () {
          setState(() {
            switch (op) {
              case 1:
                todos.add(Todo(title: et.text.toString()));
                _addTask(context);
                et.clear();
                break;
              case 2:
                todos[position] = Todo(title: et.text.toString());
                _fetchTasks();
                break;
              case 3:
                todos.removeAt(position);
                break;
              case 4:
                et.clear();
                break;
              default:
                todos.add(Todo(title: "title"));
            }
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: const Size(100, 50),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        child: Text(text),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Todo Application",
            style: TextStyle(
                color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 33),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: et,
                onSubmitted: (value) => {print(value)},
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter Your Job",
                  enabledBorder: border,
                  focusedBorder: border,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: buttonWidget(1, text: "Insert"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: buttonWidget(2, text: "Update"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: buttonWidget(3, text: "Delete"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: buttonWidget(4, text: "Clear"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            et.text = todo.title;
                            position = index;
                          });
                        },
                        child: ListTile(
                          leading: Checkbox(
                              value: todo.isDone,
                              onChanged: (bool? value) {
                                setState(() {
                                  todo.isDone = value ?? false;
                                });
                              }),
                          title: Text(todos[index].title),
                          subtitle: const Text("data"),
                          trailing: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

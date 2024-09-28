import 'package:flutter/material.dart';
import 'package:newproject/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController et = TextEditingController();

  @override
  void dispose() {
    et.dispose();
    super.dispose();
  }

  int position = 0;

  @override
  Widget build(BuildContext context) {
    final border = const OutlineInputBorder(
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
                et.clear();
              case 2:
                todos[position] = Todo(title: et.text.toString());
              case 3:
                todos.removeAt(position);
              case 4:
                et.clear();
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
            "Todo Appliction",
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
                style: TextStyle(color: Colors.black),
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
                          subtitle: Text("data"),
                          trailing: IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
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

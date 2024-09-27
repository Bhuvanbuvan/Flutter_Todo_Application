import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    );
    Widget buttonWidget({required String text}) {
      return TextButton(
        onPressed: () {},
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
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
                      child: buttonWidget(text: "Insert"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: buttonWidget(text: "Update"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: buttonWidget(text: "Delete"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: buttonWidget(text: "Clear"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

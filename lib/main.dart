import 'package:flutter/material.dart';
import './style.dart' as themeStyle;

void main() {
  runApp(MaterialApp(
      theme: themeStyle.theme,
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('instagram'),
        actions: const [Icon(Icons.add_box_outlined)],
      ),
      body: Column(
        children: [
          const Text('test'),
          ElevatedButton(
              child: const Text("test",),
              onPressed: (){},
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'shop'),
        ],

      ),
    );
  }
}
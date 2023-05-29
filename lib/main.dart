// import 'simple_animations/example_1.dart';
// import 'simple_animations/example_2.dart';
// import 'simple_animations/example_3.dart';
import '3d_transitions/my_drawer_y.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyDrawerY(),
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer'),
      ),
      body: SizedBox(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 200,
              height: 100,
              child: ListTile(
                title: Container(
                  height: 100,
                  color: Colors.black38,
                  child: Center(
                    child: Text(
                      'Item $index',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' show pi;

class MyDrawerY extends StatelessWidget {
  const MyDrawerY({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DrawerY(
      drawer: Material(
        child: Container(
          color: const Color(0xff24283b),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.8, left: 0),
          // height: 200,
          child: SizedBox(
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
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drawer'),
        ),
        body: Container(
          color: const Color(0xff414868),
        ),
      ),
    );
  }
}

class DrawerY extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  const DrawerY({required this.child, required this.drawer, Key? key})
      : super(key: key);

  @override
  State<DrawerY> createState() => _DrawerYState();
}

class _DrawerYState extends State<DrawerY> with TickerProviderStateMixin {
  late AnimationController _yAxisControllerForChild;
  late AnimationController _yAxisControllerForDrawer;
  late Animation<double> _xAxisRotationForChild;
  late Animation<double> _xAxisRotationForDrawer;
  @override
  void initState() {
    super.initState();
    _yAxisControllerForChild = AnimationController(
        vsync: this, duration: const Duration(microseconds: 500));
    _yAxisControllerForDrawer = AnimationController(
        vsync: this, duration: const Duration(microseconds: 500));

    _xAxisRotationForChild =
        Tween<double>(begin: 0, end: -pi / 2).animate(_yAxisControllerForChild);
    _xAxisRotationForDrawer = Tween<double>(begin: pi / 2.7, end: 0)
        .animate(_yAxisControllerForDrawer);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxDrag = screenHeight * 0.4;
    return AnimatedBuilder(
        animation: Listenable.merge(
          [
            _yAxisControllerForChild,
            _yAxisControllerForDrawer,
          ],
        ),
        builder: (BuildContext context, Widget? child) {
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              double delta = details.delta.dy / maxDrag;
              _yAxisControllerForChild.value += delta;
              _yAxisControllerForDrawer.value += delta;
            },
            onVerticalDragEnd: (details) {
              if (_yAxisControllerForChild.value < 0.5) {
                _yAxisControllerForChild.reverse();
                _yAxisControllerForDrawer.reverse();
              } else {
                _yAxisControllerForChild.forward();
                _yAxisControllerForDrawer.forward();
              }
            },
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFF1a1b26),
                ),
                Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(2, 3, 0.001)
                    ..translate(_yAxisControllerForDrawer.value,
                        _yAxisControllerForChild.value * maxDrag)
                    ..rotateX(_xAxisRotationForChild.value),
                  child: widget.child,
                ),
                Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(2, 3, 0.001)
                    ..translate(
                        _yAxisControllerForDrawer.value,
                        -screenHeight +
                            _yAxisControllerForDrawer.value * maxDrag)
                    ..rotateX(_xAxisRotationForDrawer.value),
                  child: widget.drawer,
                ),
              ],
            ),
          );
        });
  }
}

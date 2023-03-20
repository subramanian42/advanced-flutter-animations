import 'package:flutter/material.dart';
import 'dart:math' show pi;

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      drawer: Material(
        child: Container(
          color: const Color(0xff24283b),
          padding: const EdgeInsets.only(left: 80, top: 80),
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
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

class Drawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  const Drawer({required this.child, required this.drawer, Key? key})
      : super(key: key);
  @override
  State<Drawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<Drawer> with TickerProviderStateMixin {
  late AnimationController _xControllerForChild;
  late Animation<double> _yRotationChildAnimation;
  late Animation<double> _yRotationDrawerAnimation;
  late AnimationController _xControllerForDrawer;
  @override
  void initState() {
    super.initState();
    _xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yRotationChildAnimation = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(_xControllerForChild);
    _yRotationDrawerAnimation = Tween<double>(
      begin: pi / 2.7,
      end: 0,
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    _xControllerForChild.dispose();
    _xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxDrag = screenWidth * 0.8;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        double delta = details.delta.dx / maxDrag;
        _xControllerForChild.value += delta;
        _xControllerForDrawer.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForChild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
          [
            _yRotationDrawerAnimation,
            _yRotationChildAnimation,
          ],
        ),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: const Color(0xFF1a1b26),
              ),
              Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(_xControllerForChild.value * maxDrag)
                    ..rotateY(_yRotationChildAnimation.value),
                  child: widget.child),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                      -screenWidth + _xControllerForDrawer.value * maxDrag)
                  ..rotateY(_yRotationDrawerAnimation.value),
                child: widget.drawer,
              )
            ],
          );
        },
      ),
    );
  }
}

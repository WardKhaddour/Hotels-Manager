import 'package:flutter/material.dart';

class LogInScreenBackground extends StatelessWidget {
  const LogInScreenBackground({Key? key, required this.child})
      : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade100,
              Colors.pink.shade100,
              Colors.purpleAccent.shade100,
              Colors.pinkAccent.shade100,
            ],
          ),
        ),
        child: child);
  }
}

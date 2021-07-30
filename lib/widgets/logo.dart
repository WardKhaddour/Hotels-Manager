import 'package:flutter/material.dart';
import '../constants.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Hero(
            tag: 'logo',
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage(
                tasqmentLog,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

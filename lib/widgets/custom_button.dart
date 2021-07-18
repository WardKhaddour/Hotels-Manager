import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.onPress, required this.title})
      : super(
          key: key,
        );
  final VoidCallback onPress;
  final String title;
  void onPressed() {
    onPress;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(2),
          shadowColor:
              MaterialStateProperty.all(Theme.of(context).backgroundColor),
        ),
        onPressed: onPress,
        child: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

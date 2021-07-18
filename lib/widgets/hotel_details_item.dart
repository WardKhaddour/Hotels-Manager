import 'package:flutter/material.dart';

class HotelDetailsItem extends StatelessWidget {
  final String leadingText;
  final Widget trailing;

  const HotelDetailsItem(
      {Key? key, required this.leadingText, required this.trailing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Text(
          leadingText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        trailing: trailing,
      ),
    );
  }
}

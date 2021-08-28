import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key, required this.onTap, required this.title, required this.icon})
      : super(key: key);
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: onTap,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';

class FiltersItem extends StatefulWidget {
  const FiltersItem({
    Key? key,
    required this.title,
  });
  final String title;
  @override
  _FiltersItemState createState() => _FiltersItemState();
}

class _FiltersItemState extends State<FiltersItem> {
  bool isSelected = false;
  final hotelsController = Get.find<HotelsController>();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
      ),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            isSelected = value!;
          });
          if (value!) hotelsController.filterHotelsByLocation(widget.title);
        },
      ),
    );
  }
}

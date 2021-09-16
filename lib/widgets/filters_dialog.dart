import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';
import 'filters_item.dart';

class FiltersDialog extends StatefulWidget {
  FiltersDialog({
    Key? key,
  }) : super(key: key);

  @override
  _FiltersDialogState createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  final hotelsController = Get.find<HotelsController>();
  bool enableFiltering = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Your Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: hotelsController.hotelsLocations
            .map(
              (e) => FiltersItem(title: e),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              enableFiltering = true;
            });
            Get.back(result: enableFiltering);
            // Navigator.of(context).pop(enableFiltering);
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              enableFiltering = false;
            });
            hotelsController.clearFilters();
            Get.back(result: enableFiltering);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

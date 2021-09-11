// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/hotels_controller.dart';
// import 'filters_item.dart';

// class FiltersDropdown extends StatefulWidget {
//   @override
//   _FiltersDropdownState createState() => _FiltersDropdownState();
// }

// class _FiltersDropdownState extends State<FiltersDropdown> {
//   final hotelsController = Get.find<HotelsController>();

//   String value = '';

//   void onSelect(bool? isSelected) {}
//   void selectValue(String value) {
//     setState(() {
//       this.value = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       hint: Text('Filter'),
//       items: hotelsController.hotelsLocations
//           .map((e) => DropdownMenuItem<String>(
//                 child: FiltersItem(title: e),
//               ))
//           .toList(),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';

class SortDropdown extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  @override
  _SortDropdownState createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  String title = 'Sort';
  final hotelsController = Get.find<HotelsController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sort Hotels'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              onChanged: (value) {
                setState(() {
                  title = value!;
                  // hotelsController.sortHotels(e);
                });
              },
              hint: Text(title),
              items: sortType.values
                  .map<DropdownMenuItem<String>>(
                    (e) => DropdownMenuItem<String>(
                      value: describeEnum(e),
                      onTap: () {
                        print('tapped');
                        hotelsController.sortHotels(e);
                      },
                      // child: TextButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       // title = describeEnum(e);
                      //       // isExpand = false;
                      //     });
                      //     hotelsController.sortHotels(e);
                      //   },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          describeEnum(e),
                        ),
                      ),
                    ),
                    // ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

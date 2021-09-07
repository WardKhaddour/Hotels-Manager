import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/hotels_controller.dart';
import '../widgets/hotel_card.dart';
import 'add_hotel_screen.dart';

class MyHotelsScreen extends StatelessWidget {
  static const routeName = '/my-hotels';
  MyHotelsScreen({Key? key}) : super(key: key);
  final hotelsController = Get.find<HotelsController>();
  @override
  Widget build(BuildContext context) {
    final myHotels = hotelsController.myHotels;
    myHotels.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(
        title: Text('My Hotels'),
      ),
      body: myHotels.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You don\'t have hotels 🙁',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(AddHotelScreen.routeName);
                        },
                        child: Text(
                          'Add Now!',
                          style: TextStyle(fontSize: 24),
                        )),
                  )
                ],
              ),
            )
          : ListView(
              children: myHotels.map((e) => HotelCard(e)).toList(),
            ),
    );
  }
}

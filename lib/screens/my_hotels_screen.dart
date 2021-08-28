import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';
import '../widgets/hotel_card.dart';

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
      body: ListView(
        children: myHotels.map((e) => HotelCard(e)).toList(),
      ),
    );
  }
}

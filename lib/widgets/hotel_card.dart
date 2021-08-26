import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../screens/hotel_details_screen.dart';
import 'hotel_image.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final _hotelsController = Get.find<HotelsController>();
  final _authController = Get.find<AuthController>();
  HotelCard(this.hotel);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(HotelDetailsScreen.routeName, arguments: {'hotel': hotel});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: HotelImage(
                    imageUrl: hotel.imageUrl,
                  ),
                ),
                title: Text(hotel.name),
                trailing: hotel.rate < 0
                    ? Text('Not Rated')
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(hotel.rate.toStringAsFixed(1)),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.star),
                        ],
                      ),
              ),
              hotel.authorEmail == _authController.currentUser
                  ? TextButton(
                      style: ButtonStyle(alignment: Alignment.centerLeft),
                      onPressed: () {
                        //TODO take room
                        _hotelsController.takeRoom(hotel);
                      },
                      child: Text(
                        'Take Room',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

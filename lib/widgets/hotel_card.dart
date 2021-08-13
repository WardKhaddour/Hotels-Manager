import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../screens/hotel_details_screen.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final _hotelsController = Get.find<HotelsController>();
  final _authController = Get.find<AuthController>();
  HotelCard(this.hotel);
  @override
  Widget build(BuildContext context) {
    print('user ${_authController.currentUser}');
    print('hotel ${hotel.authorEmail}');
    return GestureDetector(
      onTap: () {
        Get.toNamed(HotelDetailsScreen.routeName, arguments: {'id': hotel.id});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(hotel.imageUrl),
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
            subtitle: hotel.authorEmail == _authController.currentUser
                ? TextButton(
                    onPressed: () {
                      //TODO take room
                      _hotelsController.takeRoom(hotel);
                    },
                    child: Text(
                      'Take Room',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ),
    );
  }
}

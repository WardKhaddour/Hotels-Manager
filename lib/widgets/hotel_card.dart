import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/hotel.dart';
import '../screens/hotel_details_screen.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  HotelCard(this.hotel);
  @override
  Widget build(BuildContext context) {
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
            trailing: Row(
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
            //   hotel.authorEmail == AuthController().currentUser
            //       ? TextButton.icon(
            //           onPressed: () {
            //             //TODO take room
            //           },
            //           icon: Icon(Icons.takeout_dining),
            //           label: Text('Take Room'),
            //         )
            //       : SizedBox(),
            // ],
          ),
        ),
      ),
    );
  }
}

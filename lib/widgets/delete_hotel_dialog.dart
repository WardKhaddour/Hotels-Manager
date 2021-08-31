import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';

class DeleteHotelDialog extends StatelessWidget {
  const DeleteHotelDialog({
    Key? key,
    required HotelsController hotelsController,
    required this.currentHotel,
  })   : _hotelsController = hotelsController,
        super(key: key);

  final HotelsController _hotelsController;
  final Hotel? currentHotel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure'),
      content: Text('Delete hotel?'),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text('No'),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            await _hotelsController.deleteHotel(
              currentHotel!.documentId!,
            );
            Get.back();
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}

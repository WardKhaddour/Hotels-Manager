import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';

class RateDialog extends StatefulWidget {
  const RateDialog({Key? key, required this.currentHotel}) : super(key: key);
  final Hotel currentHotel;
  @override
  _RateDialogState createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  int rate = 0;
  final authController = Get.find<AuthController>();
  final hotelsController = Get.find<HotelsController>();
  Future<void> addRate() async {
    hotelsController.rateHotel(
        widget.currentHotel, authController.currentUser, rate);
  }

  @override
  void initState() {
    super.initState();
    rate = widget.currentHotel.rates[authController.currentUser] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      actionsPadding: EdgeInsets.all(10),
      title: Text('Add your rate'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 1; i <= 5; ++i)
            IconButton(
              icon: Icon(
                Icons.star,
                color: i <= rate ? Color(0xFFBCB82E) : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  rate = i;
                });
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: rate.toDouble());
            addRate();
          },
          child: Text('Rate'),
        ),
      ],
    );
  }
}

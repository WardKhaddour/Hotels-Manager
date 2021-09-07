import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hotel.dart';
import 'gradient_icon.dart';
import 'rate_dialog.dart';

class HotelRate extends StatelessWidget {
  const HotelRate(
      {Key? key,
      required this.rate,
      required this.currentHotel,
      required this.enableEditing})
      : super(key: key);
  final double rate;
  final Hotel currentHotel;
  final bool enableEditing;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rate < 0
          ? <Widget>[
              Row(children: [
                Text('Not Rated'),
              ]),
              enableEditing
                  ? SizedBox()
                  : TextButton(
                      child:
                          Text('Rate', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Get.dialog(
                          RateDialog(currentHotel: currentHotel),
                        );
                      }),
            ]
          : <Widget>[
              Row(children: [
                for (int i = 0; i < rate.toInt(); ++i)
                  Icon(
                    Icons.star,
                    color: Color(0xFFBCB82E),
                  ),
                if (rate.toInt() != rate)
                  GradientIcon(
                      child: Icon(
                        Icons.star,
                      ),
                      colors: [Color(0xFFBCB82E), Colors.white]),
              ]),
              enableEditing
                  ? SizedBox()
                  : TextButton(
                      child:
                          Text('Rate', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Get.dialog(
                          RateDialog(
                            currentHotel: currentHotel,
                          ),
                        );
                      }),
            ],
    );
  }
}

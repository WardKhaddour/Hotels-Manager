import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hotel.dart';
import 'gradient_icon.dart';
import 'rate_dialog.dart';

class HotelRate extends StatefulWidget {
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
  _HotelRateState createState() => _HotelRateState();
}

class _HotelRateState extends State<HotelRate> {
  double? rate;
  @override
  void initState() {
    super.initState();
    rate = widget.rate;
  }

  @override
  Widget build(BuildContext context) {
    // rate = widget.rate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      children: rate! < 0
          ? <Widget>[
              Row(children: [
                Text(
                  'Not Rated',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ]),
              widget.enableEditing
                  ? SizedBox()
                  : TextButton(
                      onPressed: () {
                        Get.dialog(
                          RateDialog(currentHotel: widget.currentHotel),
                        ).then((value) {
                          if (value == null) return;
                          setState(() {
                            rate = value as double;
                          });
                        });
                      },
                      child: RateButtonStyleing(),
                    ),
            ]
          : <Widget>[
              Row(children: [
                for (int i = 0; i < rate!.toInt(); ++i)
                  Icon(
                    Icons.star,
                    color: Color(0xFFBCB82E),
                  ),
                if (rate!.toInt() != rate)
                  GradientIcon(
                      child: Icon(
                        Icons.star,
                      ),
                      colors: [Color(0xFFBCB82E), Colors.white]),
              ]),
              widget.enableEditing
                  ? SizedBox()
                  : TextButton(
                      onPressed: () {
                        Get.dialog(
                          RateDialog(currentHotel: widget.currentHotel),
                        ).then((value) {
                          if (value == null) return;
                          setState(() {
                            rate = value as double;
                          });
                        });
                      },
                      child: RateButtonStyleing(),
                    ),
            ],
    );
  }
}

class RateButtonStyleing extends StatelessWidget {
  const RateButtonStyleing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          'Add Rate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontFamily: 'Uchen',
            shadows: <Shadow>[
              Shadow(color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

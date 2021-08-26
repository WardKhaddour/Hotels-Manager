import 'package:flutter/material.dart';

class HotelImage extends StatelessWidget {
  const HotelImage({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage(
        'assets/images/hotel.png',
      ),
      image: NetworkImage(imageUrl),
    );
  }
}

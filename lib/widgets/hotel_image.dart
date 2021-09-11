import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotelImage extends StatelessWidget {
  const HotelImage({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(AlertDialog(
          title: IconButton(
            icon: Icon(Icons.close),
            onPressed: Get.back,
          ),
          content: FadeInImage(
            fit: BoxFit.fill,
            placeholder: AssetImage(
              'assets/images/hotel.png',
            ),
            image: NetworkImage(imageUrl),
          ),
        ));
      },
      child: Container(
        width: 50,
        height: 50,
        child: FadeInImage(
          fit: BoxFit.fill,
          placeholder: AssetImage(
            'assets/images/hotel.png',
          ),
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}

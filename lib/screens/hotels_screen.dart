import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';
import '../widgets/hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  static const String routeName = '/hotels-screen';

  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final hotelsController = Get.find<HotelsController>();
  bool searchMode = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final hotels = hotelsController.hotels.value;
    final searchHotels = hotelsController.search(searchText);

    return Scaffold(
      appBar: AppBar(
        title: searchMode
            ? TextField(
                onChanged: (val) {
                  setState(() {
                    searchText = val;
                  });
                },
              )
            : Text('Hotels'),
        actions: [
          IconButton(
            icon: Icon(searchMode ? Icons.arrow_forward : Icons.search),
            onPressed: () {
              setState(() {
                searchMode = !searchMode;
              });
            },
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) =>
              HotelCard(searchMode ? searchHotels![i] : hotels[i]),
          itemCount: searchMode ? searchHotels!.length : hotels.length,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../screens/login_screen.dart';
import '../widgets/hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  static const String routeName = '/hotels-screen';

  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final hotelsController = HotelsController();
  final authController = AuthController();
  bool searchMode = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final hotels = hotelsController.hotels;
    final searchHotels = hotelsController.search(searchText);

    return Scaffold(
      appBar: AppBar(
        title: searchMode
            ? TextField(
                autofocus: true,
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
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authController.logout();
                Get.offNamed(LogInScreen.routeName);
              })
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

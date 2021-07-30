import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../screens/login_screen.dart';
import '../widgets/hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  static const String routeName = '/hotels-screen';

  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final hotelsController = Get.find<HotelsController>();
  final authController = Get.find<AuthController>();
  bool searchMode = false;
  String searchText = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await hotelsController.fetchHotels();
      setState(() {
        _isLoading = false;
      });
    });
  }

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
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) =>
                          HotelCard(searchMode ? searchHotels![i] : hotels[i]),
                      itemCount:
                          searchMode ? searchHotels!.length : hotels.length,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        hotelsController.addHotel(
                          Hotel(
                              id: DateTime.now().toString(),
                              name: "sd",
                              rate: 4,
                              phoneNumber: 4555,
                              imageUrl: '',
                              location: 'damas',
                              roomsCount: 455),
                        );
                      },
                      child: Text('Add hotel')),
                ],
              ));
  }
}

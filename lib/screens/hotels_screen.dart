// import 'package:cloud_firestore/cloud_firestore.dart';
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
  // bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((value) async {
      //   setState(() {
      //     _isLoading = true;
      //   });
      await hotelsController.fetchHotels();
      //   setState(() {
      //     _isLoading = false;
      //   });
    });
  }

  void addHotel(QueryDocumentSnapshot<Map<String, dynamic>> element) {
    hotelsController.hotels.add(Hotel.fromDocuments(element.data()));
  }

  @override
  Widget build(BuildContext context) {
    // final hotels = hotelsController.hotels;
    final searchHotels = hotelsController.search(searchText);
    final _hotelsStream = FirebaseFirestore.instance
        .collection('hotels')
        .snapshots(includeMetadataChanges: true);
    _hotelsStream.listen((event) {
      event.docs.forEach(addHotel);
    });
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
      body: Obx(
        () => hotelsController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: _hotelsStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Something went wrong'),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return !searchMode
                              ? ListView(
                                  children: snapshot.data!.docs.map((document) {
                                    var data =
                                        document.data() as Map<String, dynamic>;
                                    return HotelCard(Hotel.fromDocuments(data));
                                  }).toList(),
                                  // itemBuilder: (context, i) => HotelCard(
                                  //     searchMode
                                  //         ? hotelsController
                                  //             .search(searchText)![i]
                                  //         : hotelsController.hotels[i]),
                                  // itemCount: searchMode
                                  //     ? hotelsController
                                  //         .search(searchText)!
                                  //         .length
                                  //     : hotelsController.hotels.length,
                                )
                              : ListView.builder(
                                  itemBuilder: (context, index) =>
                                      HotelCard(searchHotels![index]),
                                  itemCount: searchHotels!.length,
                                );
                        }),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        hotelsController.addHotel(
                          Hotel(
                              authorEmail: authController.currentUser,
                              id: DateTime.now().toString(),
                              name: "faslknfas",
                              rate: 4,
                              phoneNumber: 4555,
                              imageUrl: '',
                              location: 'damas',
                              roomsCount: 455),
                        );
                      },
                      child: Text('Add hotel')),
                ],
              ),
      ),
    );
  }
}

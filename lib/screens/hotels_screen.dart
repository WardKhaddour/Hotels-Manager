import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/hotel_card.dart';
import './add_hotel_screen.dart';
import './login_screen.dart';

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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((value) async {
      await hotelsController.fetchHotels();
    });
  }

  void updateHotels() {
    hotelsController.fetchHotels();
  }

  @override
  Widget build(BuildContext context) {
    final searchHotels = hotelsController.search(searchText);
    final _hotelsStream = FirebaseFirestore.instance
        .collection('hotels')
        .snapshots(includeMetadataChanges: true);
    _hotelsStream.listen((event) {
      updateHotels();
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
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 10),
              child: Container(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/tasqment-logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Hotel'),
                onTap: () {
                  Get.toNamed(AddHotelScreen.routeName);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  authController.logout();
                  Get.offNamed(LogInScreen.routeName);
                },
              ),
            ),
          ],
        ),
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
                                children: snapshot.data!.docs.map(
                                  (document) {
                                    var data =
                                        document.data() as Map<String, dynamic>;
                                    print(document.id);
                                    return HotelCard(
                                        Hotel.fromDocuments(data, document.id));
                                  },
                                ).toList(),
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) =>
                                    HotelCard(searchHotels![index]),
                                itemCount: searchHotels!.length,
                              );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

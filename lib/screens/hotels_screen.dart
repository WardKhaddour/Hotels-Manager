import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/app_drawer.dart';
import '../widgets/filters_dialog.dart';
import '../widgets/hotel_card.dart';
import '../widgets/sort_dropdown.dart';

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
  String title = 'Sort';
  Map<String, List<Hotel>> hotelsByLocation = {};
  bool isLoading = false;
  bool enableFiltering = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 0)).then((value) async {
      await hotelsController.fetchHotels();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchHotels = hotelsController.search(searchText);
    hotelsByLocation = hotelsController.hotelsByLocation;

    // final _hotelsStream = FirebaseFirestore.instance
    //     .collection('hotels')
    //     .snapshots(includeMetadataChanges: false);
    // _hotelsStream.listen((event) {
    //   // hotelsController.fetchHotels();
    // });
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
            icon: Icon(searchMode ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                searchMode = !searchMode;
              });
            },
          ),
          IconButton(
            icon: Icon(enableFiltering ? Icons.close : Icons.filter_list),
            onPressed: () {
              hotelsController.clearFilters();
              setState(() {
                enableFiltering = !enableFiltering;
              });
              !enableFiltering
                  ? null
                  : Get.dialog(FiltersDialog()).then((value) {
                      print(value);
                      setState(() {
                        enableFiltering = value as bool;
                      });
                    });
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await hotelsController.fetchHotels();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: enableFiltering
                    ? [
                        Expanded(
                          child: ListView(
                            children: hotelsController.filteredHotels
                                .map((element) => HotelCard(element))
                                .toList(),
                          ),
                        ),
                      ]
                    : [
                        if (!searchMode) SortDropdown(),
                        Expanded(
                            // child: StreamBuilder<QuerySnapshot>(
                            //   stream: _hotelsStream,
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasError) {
                            //       return Center(
                            //         child: Text('Something went wrong'),
                            //       );
                            //     }
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Center(
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }
                            child: !searchMode
                                ? Obx(
                                    () => ListView(
                                      //   children: snapshot.data!.docs.map(
                                      //     (document) {
                                      //       var data = document.data()
                                      //           as Map<String, dynamic>;
                                      //       return HotelCard(Hotel.fromDocuments(
                                      //           data, document.id));
                                      //     },
                                      //   ).toList(),
                                      // )
                                      children: [
                                        for (var key in hotelsByLocation.keys)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.location_on),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      key,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: hotelsByLocation[key]!
                                                    .map((e) => HotelCard(e))
                                                    .toList(),
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemBuilder: (context, index) =>
                                        HotelCard(searchHotels![index]),
                                    itemCount: searchHotels!.length,
                                  ))
                      ]),
      ),
      // ],

      // ),
      // ),
    );
  }
}

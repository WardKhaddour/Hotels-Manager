import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../widgets/app_drawer.dart';
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
  String title = 'Sort';
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
    // final _hotelsStream = FirebaseFirestore.instance
    //     .collection('hotels')
    //     .snapshots(includeMetadataChanges: true);
    // _hotelsStream.listen((event) {
    //   updateHotels();
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
            icon: Icon(searchMode ? Icons.arrow_forward : Icons.search),
            onPressed: () {
              setState(() {
                searchMode = !searchMode;
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
        child: Obx(
          () => hotelsController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      if (!searchMode)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Sort Hotels'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  onChanged: (value) {
                                    setState(() {
                                      title = value!;
                                      // hotelsController.sortHotels(e);
                                    });
                                  },
                                  hint: Text(title),
                                  items: sortType.values
                                      .map<DropdownMenuItem<String>>(
                                        (e) => DropdownMenuItem<String>(
                                          value: describeEnum(e),
                                          onTap: () {
                                            print('tapped');
                                            hotelsController.sortHotels(e);
                                          },
                                          // child: TextButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       // title = describeEnum(e);
                                          //       // isExpand = false;
                                          //     });
                                          //     hotelsController.sortHotels(e);
                                          //   },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              describeEnum(e),
                                            ),
                                          ),
                                        ),
                                        // ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              ? ListView(
                                  //   children: snapshot.data!.docs.map(
                                  //     (document) {
                                  //       var data = document.data()
                                  //           as Map<String, dynamic>;
                                  //       return HotelCard(Hotel.fromDocuments(
                                  //           data, document.id));
                                  //     },
                                  //   ).toList(),
                                  // )
                                  children: hotelsController.hotels
                                      .map((element) => HotelCard(element))
                                      .toList(),
                                )
                              : ListView.builder(
                                  itemBuilder: (context, index) =>
                                      HotelCard(searchHotels![index]),
                                  itemCount: searchHotels!.length,
                                ))
                    ]),
        ),
        // ],
      ),
      // ),
      // ),
    );
  }
}

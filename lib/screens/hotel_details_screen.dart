import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/hotel_details_item.dart';

class HotelDetailsScreen extends StatelessWidget {
  static const routeName = '/hotel-details';
  //TODO get the product id from arguments
  // final String _productId =
  //     Get.arguments != null ? Get.arguments['id'] as String : '';
  final ScrollController _scrollController = ScrollController();
  final hotelsController = HotelsController();
  Widget _buildRate(int rate) {
    return rate == -1
        ? Text('Not Rated')
        : Row(
            children: <Widget>[
              for (int i = 0; i < rate; i++)
                Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = hotelsController.hotels[0];
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  hotelsController.addHotels(Hotel(
                      id: "ffsd",
                      name: "sdf",
                      numberOfRooms: 5,
                      location: 'location'));
                },
              )
            ],
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: _buildRate(hotel.rate),
              background: Image.asset('image'),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HotelDetailsItem(
                      leadingText: hotel.name,
                      trailing: Icon(Icons.hotel),
                    ),
                    HotelDetailsItem(
                      leadingText: hotel.location,
                      trailing: Icon(Icons.location_on),
                    ),
                    HotelDetailsItem(
                      leadingText: '${hotel.numberOfRooms} Rooms',
                      trailing: Icon(Icons.meeting_room),
                    ),
                    HotelDetailsItem(
                      leadingText: '${hotel.phoneNumber}',
                      trailing: IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () async {
                          if (await canLaunch("tel://${hotel.phoneNumber}")) {
                            await launch("tel://${hotel.phoneNumber}");
                          } else {
                            print('Cannot make call');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:get/get.dart';
import '../models/hotel.dart';

class HotelsController extends GetxController {
  List<Hotel> hotels = <Hotel>[
    Hotel(id: 'id', name: 'name', numberOfRooms: 10, location: 'location'),
  ].obs;
  void addHotels(Hotel newHotel) {
    hotels.add(newHotel);
    hotels.forEach(print);
  }
}

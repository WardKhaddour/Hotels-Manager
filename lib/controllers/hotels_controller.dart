import 'package:get/get.dart';
import '../models/hotel.dart';
import '../services/firestore.dart';
// import '../models/location.dart';

String url =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO-REY6u_fZJ0EfWq9Yqm0T8qZvHe8pfwsiw&usqp=CAU';

class HotelsController extends GetxController {
  @override
  void onInit() async {
    final firestore = FirestoreService();
    print(1);
    hotels.value = await firestore.fetchHotels() ?? [];
    print(hotels.value.length);
    super.onInit();
  }

  final RxList<Hotel> hotels = [
    Hotel(
        name: 'LaMera',
        // location: Location(21.0542, 25.454252),
        location: 'lattakia ',
        roomsCount: 500,
        id: '54445kjgjh',
        imageUrl: url,
        rate: 4.0,
        phoneNumber: 0000),
    Hotel(
        name: 'A7a',
        // location: Location(21.0542, 25.454252),
        location: 'lattakia ',
        roomsCount: 500,
        id: '34445kjgjh',
        imageUrl: url,
        rate: 2.0,
        phoneNumber: 00900)
  ].obs;

  Future<void>? fetchHotels() async {
    //TODO: fetch hotels from server
  }

  Future<void>? addHotel(Hotel hotel) async {
    hotels.add(hotel);
    //TODO: add the hotel to the server
  }

  List<Hotel>? search(String? searchText) {
    if (searchText == '') return [];
    final all = hotels;
    final res = all
        .where((element) =>
            element.name.toLowerCase().contains(searchText!.toLowerCase()))
        .toList();
    return res;
  }

  Future<void> editHotel(Hotel hotel) async {}
  Hotel findById(String id) {
    return hotels.firstWhere((element) => element.id == id);
  }
}

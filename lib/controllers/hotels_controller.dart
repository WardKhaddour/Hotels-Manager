import 'package:get/get.dart';
import '../models/hotel.dart';
import '../services/firestore.dart';

// String url =
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO-REY6u_fZJ0EfWq9Yqm0T8qZvHe8pfwsiw&usqp=CAU';

class HotelsController extends GetxController {
  RxList<Hotel> hotels = <Hotel>[].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() async {
    super.onInit();
    print("init controller");
    // final firestore = FirestoreService();
    isLoading.toggle();
    print('loading before fitchung $isLoading');
    final fetchedHotels = await FirestoreService().fetchHotels();
    hotels.value += fetchedHotels!;
    print('hotels $hotels'); // hotels = await firestore.fetchHotels() ?? [];
    isLoading.toggle();
    print('loading after fitchung $isLoading');
    print("finish fitching");
  }

  // RxList<Hotel> hotels = [
  //   Hotel(
  //       name: 'LaMera',
  //       // location: Location(21.0542, 25.454252),
  //       location: 'lattakia ',
  //       roomsCount: 500,
  //       id: '54445kjgjh',
  //       imageUrl: url,
  //       rate: 4.0,
  //       phoneNumber: 0000),
  //   Hotel(
  //       name: 'A7a',
  //       // location: Location(21.0542, 25.454252),
  //       location: 'lattakia ',
  //       roomsCount: 500,
  //       id: '34445kjgjh',
  //       imageUrl: url,
  //       rate: 2.0,
  //       phoneNumber: 00900)
  // ].obs;
  // Future<void>? fetchHotels() async {
  //   print('length before fetch ${hotels.length}');
  //   final fetchedHotels = await FirestoreService().fetchHotels();
  //   hotels.value += fetchedHotels!;

  //   print('length after fetch ${hotels.length}');
  // }

  Future<void> addHotel(Hotel hotel) async {
    hotels.add(hotel);
    await FirestoreService().addHotel(hotel);
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

  Future<void> editHotel(Hotel hotel) async {
    final hotelIndex = hotels.indexWhere((element) => element.id == hotel.id);
    if (hotelIndex >= 0) {
      hotels[hotelIndex] = hotel;
    }
  }

  Hotel findById(String id) {
    return hotels.firstWhere((hotel) => hotel.id == id);
  }
  // Hotel findById(String id) {
  //   var currentHotel = Hotel(
  //       name: "name",
  //       location: "location",
  //       roomsCount: 0,
  //       id: "id",
  //       imageUrl: "imageUrl",
  //       rate: 0.0,
  //       phoneNumber: 555);
  //   print(hotels.length);
  //   for (var hotel in hotels) {
  //     if (hotel.id == id) {
  //       print('equals');
  //       currentHotel = hotel;
  //       break;
  //     }
  //   }
  //   return currentHotel;
  // }
}

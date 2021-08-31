import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/hotel.dart';
import '../services/firestore.dart';
import 'auth_controller.dart';

enum sortType {
  Name,
  Location,
  RoomPrice,
  EmptyRooms,
}
// String url =
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO-REY6u_fZJ0EfWq9Yqm0T8qZvHe8pfwsiw&usqp=CAU';

class HotelsController extends GetxController {
  RxList<Hotel> hotels = <Hotel>[].obs;
  RxBool isLoading = false.obs;
  final authController = Get.find<AuthController>();
  void sortHotels(sortType sortBy) {
    switch (sortBy) {
      case sortType.Name:
        hotels.sort((a, b) => a.name.compareTo(b.name));
        break;
      case sortType.Location:
        hotels.sort((a, b) => a.location.compareTo(b.location));
        break;
      case sortType.RoomPrice:
        hotels.sort((a, b) => a.roomPrice.compareTo(b.roomPrice));
        break;
      case sortType.EmptyRooms:
        hotels.sort((a, b) => a.emptyRooms.compareTo(b.emptyRooms));
        break;
    }
    hotels.forEach(print);
  }

  List<Hotel> get myHotels {
    return hotels
        .where((hotel) => hotel.authorEmail == authController.currentUser)
        .toList();
  }

  Future<void>? fetchHotels() async {
    final fetchedHotels = await FirestoreService().fetchHotels();
    hotels.value = fetchedHotels!;

    // hotels.sort((a, b) => a.roomPrice.compareTo(b.roomPrice));
  }

  Future<void> rateHotel(
      Hotel currentHotel, String currentUser, int rate) async {
    try {
      final fireStore = FirebaseFirestore.instance;
      final newRates = currentHotel.rates;
      newRates[currentUser] = rate;
      await fireStore
          .collection('hotels')
          .doc(currentHotel.documentId)
          .update({'rates': newRates});
      await fetchHotels();
    } on Exception catch (e) {
      Get.snackbar("An error Ocuured", e.toString());
    }
  }

  Future<void> addHotel(Hotel hotel) async {
    try {
      isLoading = true.obs;
      await FirestoreService().addHotel(hotel);
      await fetchHotels();
      isLoading = false.obs;
    } on FirebaseException catch (e) {
      Get.snackbar("An error Ocuured", e.toString());
    }
  }

  List<Hotel>? search(String? searchText) {
    if (searchText == '') return [];
    return hotels
        .where((element) =>
            element.name.toLowerCase().contains(searchText!.toLowerCase()))
        .toList();
  }

  Future<void> editHotel(Hotel hotel, String documentId) async {
    try {
      await FirestoreService().updateHotel(hotel, documentId);
      await fetchHotels();
    } on Exception catch (e) {
      Get.snackbar("An error Ocuured", e.toString());
    }
  }

  Future<void> deleteHotel(String documentId) async {
    // isLoading = true.obs;
    try {
      await FirestoreService().deleteHotel(documentId);
      await fetchHotels();
    } on Exception catch (e) {
      Get.snackbar("An error Ocuured", e.toString());
    }

    // isLoading = false.obs;
  }

  Future<void> takeRoom(Hotel currentHotel) async {
    try {
      await FirestoreService().takeRoom(currentHotel);
      await fetchHotels();
    } on Exception catch (e) {
      Get.snackbar("An error Ocuured", e.toString());
    }
  }

  Hotel findById(String id) {
    return hotels.firstWhere((hotel) => hotel.id == id);
  }

  Set<String> get hotelsLocations {
    var temp = <String>{};
    for (var hotel in hotels) {
      temp.add(hotel.location);
    }
    print(temp);
    return temp;
  }

  Map<String, List<Hotel>> get hotelsByLocation {
    var temp = <String, List<Hotel>>{};
    for (var location in hotelsLocations) {
      temp[location] =
          hotels.where((hotel) => hotel.location == location).toList();
    }
    return temp;
  }
}

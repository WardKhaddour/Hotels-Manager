import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/hotel.dart';
import '../services/firestore.dart';

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
  }

  Future<void>? fetchHotels() async {
    final fetchedHotels = await FirestoreService().fetchHotels();
    hotels.value = fetchedHotels!;
    hotels.sort((a, b) => a.roomPrice.compareTo(b.roomPrice));
  }

  Future<void> rateHotel(
      Hotel currentHotel, String currentUser, int rate) async {
    final fireStore = FirebaseFirestore.instance;
    final newRates = currentHotel.rates;
    newRates[currentUser] = rate;
    await fireStore
        .collection('hotels')
        .doc(currentHotel.documentId)
        .update({'rates': newRates});
  }

  Future<void> addHotel(Hotel hotel) async {
    try {
      await FirestoreService().addHotel(hotel);
    } on FirebaseException catch (e) {
      print(e);
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
    await FirestoreService().updateHotel(hotel, documentId);
  }

  Future<void> deleteHotel(String documentId) async {
    await FirestoreService().deleteHotel(documentId);
  }

  Future<void> takeRoom(Hotel currentHotel) async {
    await FirestoreService().takeRoom(currentHotel);
  }

  Hotel findById(String id) {
    return hotels.firstWhere((hotel) => hotel.id == id);
  }
}

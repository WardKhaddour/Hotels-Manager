import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel.dart';

class FirestoreService {
  final fireStore = FirebaseFirestore.instance;

  Future<List<Hotel>?> fetchHotels() async {
    try {
      CollectionReference hotelsCollection = fireStore.collection('hotels');
      final hotelsRes = (await hotelsCollection.get()).docs;
      List<Hotel> fetchedHotels;
      fetchedHotels = [];
      for (var e in hotelsRes) {
        var hotelData = e.data() as Map<String, dynamic>;
        fetchedHotels.add(Hotel.fromDocuments(hotelData, e.id));
      }
      return fetchedHotels;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<Hotel?> fetchHotel(String documentId) async {
    final updatedHotelDocs =
        await fireStore.collection('hotels').doc(documentId).get();
    final updatedHotel =
        Hotel.fromDocuments(updatedHotelDocs.data()!, documentId);
    print('updated Hotel $updatedHotel');
    return updatedHotel;
  }

  Future<void> addHotel(Hotel newHotel) async {
    final collection = fireStore.collection('hotels');
    await collection.add({
      'imageUrl': newHotel.imageUrl,
      'location': newHotel.location,
      'name': newHotel.name,
      'phoneNumber': newHotel.phoneNumber,
      'rates': newHotel.rates,
      'roomsCount': newHotel.roomsCount,
      'id': newHotel.id,
      'roomPrice': newHotel.roomPrice.toDouble(),
      'authorEmail': newHotel.authorEmail.toString(),
      'emptyRooms': newHotel.roomsCount.toInt(),
    });
    // await fetchHotels();
  }

  Future<void> deleteHotel(String documentId) async {
    await fireStore.collection('hotels').doc(documentId).delete();
  }

  Future<void> takeRoom(Hotel currentHotel) async {
    final fireStore = FirebaseFirestore.instance;
    var emptyRooms = currentHotel.emptyRooms;
    emptyRooms--;
    await fireStore
        .collection('hotels')
        .doc(currentHotel.documentId)
        .update({'emptyRooms': emptyRooms});
  }

  Future<void> updateHotel(Hotel hotel, String documentId) async {
    final document = fireStore.collection('hotels').doc(documentId);
    await document.update({
      'imageUrl': hotel.imageUrl,
      'location': hotel.location,
      'name': hotel.name,
      'phoneNumber': hotel.phoneNumber,
      'rates': hotel.rates,
      'roomsCount': hotel.roomsCount,
      'id': hotel.id,
      'roomPrice': hotel.roomPrice,
      'authorEmail': hotel.authorEmail,
      'emptyRooms': hotel.emptyRooms,
    });
  }
}

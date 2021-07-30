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
        fetchedHotels.add(Hotel.fromDocuments(hotelData));
      }

      // for (var e in dataMap) {
      //   fetchedHotels.add(Hotel(
      //       id: e.get('id') as String,
      //       name: e.get('name') as String,
      //       imageUrl: e.get('imageUrl') as String,
      //       rate: e.get('rate') as double,
      //       phoneNumber: e.get('phoneNumber') as int,
      //       location: e.get('location') as String,
      //       roomsCount: e.get('roomsCount') as int));
      // }
      return fetchedHotels;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> addHotel(Hotel newHotel) async {
    final collection = fireStore.collection('hotels');
    await collection.add({
      'imageUrl': newHotel.imageUrl,
      'location': newHotel.location,
      'name': newHotel.name,
      'phoneNumber': newHotel.phoneNumber,
      'rate': newHotel.rate,
      'roomCount': newHotel.roomsCount,
      'id': newHotel.id,
    });
  }
}

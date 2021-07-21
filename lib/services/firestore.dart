import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel.dart';

class FirestoreService {
  final fireStore = FirebaseFirestore.instance;

  Future<List<Hotel>?> fetchHotels() async {
    try {
      CollectionReference hotelsCollection = fireStore.collection('hotels');
      final hotelsRes = await hotelsCollection.get();
      List<Hotel> fetchedHotels;
      fetchedHotels = [];
      for (var e in hotelsRes.docs) {
        fetchedHotels.add(Hotel(
            id: e['id'] as String,
            name: e['name'] as String,
            imageUrl: e['imageUrl'] as String,
            rate: e['rate'] as double,
            phoneNumber: e['phoneNumber'] as int,
            location: e['location'] as String,
            roomsCount: e['roomCount'] as int));
      }
      print(fetchedHotels);
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

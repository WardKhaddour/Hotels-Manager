import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel.dart';

class FirestoreService {
  final fireStore = FirebaseFirestore.instance;

  Future<List<Hotel>?> fetchHotels() async {
    try {
      CollectionReference hotelsCollection = fireStore.collection('hotels');
      final hotelsRes = await hotelsCollection.get();
      List<Hotel> fetchedHotels = [];
      hotelsRes.docs.forEach((e) {
        fetchedHotels.add(Hotel(
            id: e.id,
            name: e['name'] as String,
            imageUrl: e['imageUrl'] as String,
            rate: e['rate'] as double,
            phoneNumber: e['phoneNumber'] as int,
            location: e['location'] as String,
            roomsCount: e['roomCount'] as int));
      });
      print(fetchedHotels);
      return fetchedHotels;
    } on Exception catch (_) {
      return null;
    }
  }
}

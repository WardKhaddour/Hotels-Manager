import './location.dart';

class Hotel {
  final String name;
  final String id;
  final int roomsCount;
  final Location location;
  final String imageUrl;
  final double rate;
  final int phoneNumber;

  Hotel(
      {required this.name,
      required this.location,
      required this.roomsCount,
      required this.id,
      required this.imageUrl,
      required this.rate,
      required this.phoneNumber});
}

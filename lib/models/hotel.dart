import './location.dart';

class Hotel {
  final String name;
  final String id;
  final int roomsCount;
  final Location location;
  final String imageUrl;
  final double rate;

  Hotel(this.name, this.location, this.roomsCount, this.id, this.imageUrl,
      this.rate);
}

class Hotel {
  final String name;
  final String id;
  final int roomsCount;
  final String location;
  final String imageUrl;
  final double rate;
  final int phoneNumber;
  factory Hotel.fromDocuments(Map<String, dynamic> data) {
    return Hotel(
      id: data['id'] as String,
      imageUrl: data['imageUrl'] as String,
      location: data['location'] as String,
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as int,
      rate: data['rate'] as double,
      roomsCount: data['roomCount'] as int,
    );
  }
  Hotel({
    required this.name,
    required this.location,
    required this.roomsCount,
    required this.id,
    required this.imageUrl,
    required this.rate,
    required this.phoneNumber,
  });
}

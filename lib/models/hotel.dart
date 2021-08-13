class Hotel {
  final String name;
  final String id;
  final int roomsCount;
  final String location;
  final String imageUrl;
  final Map<String, int> rates;
  final int phoneNumber;
  int? emptyRooms = 0;
  final double roomPrice;
  final String authorEmail;
  String? documentId;
  factory Hotel.fromDocuments(Map<String, dynamic> data, String id) {
    return Hotel(
      id: data['id'] as String,
      imageUrl: data['imageUrl'] as String,
      location: data['location'] as String,
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as int,
      rates: Map.castFrom<String, dynamic, String, int>(
          data['rates'] as Map<String, dynamic>),
      roomsCount: data['roomsCount'] as int,
      roomPrice: data['roomPrice'] as double,
      documentId: id,
      authorEmail: data['authorEmail'].toString(),
      emptyRooms: data['emptyRooms'] as int,
    );
  }
  double get rate {
    var sum = 0;
    if (rates.length <= 0) {
      return -1;
    }
    for (var item in rates.values) {
      sum += item;
    }
    return sum / rates.length;
  }

  Hotel({
    required this.name,
    required this.location,
    required this.roomsCount,
    required this.id,
    required this.imageUrl,
    required this.rates,
    required this.phoneNumber,
    required this.roomPrice,
    required this.authorEmail,
    this.documentId,
    this.emptyRooms,
  });
}

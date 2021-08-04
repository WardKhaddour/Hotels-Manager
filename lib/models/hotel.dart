class Hotel {
  final String name;
  final String id;
  final int roomsCount;
  final String location;
  final String imageUrl;
  final List<int> rates;
  final int phoneNumber;
  final double roomPrice;
  String? authorEmail;
  factory Hotel.fromDocuments(Map<String, dynamic> data) {
    return Hotel(
      id: data['id'] as String,
      imageUrl: data['imageUrl'] as String,
      location: data['location'] as String,
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as int,
      rates: List.castFrom<dynamic, int>(data['rates'] as List),
      roomsCount: data['roomsCount'] as int,
      roomPrice: data['roomPrice'] as double,
    );
  }
  double get rate {
    var sum = 0;
    for (var item in rates) {
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
    this.authorEmail,
  });
}

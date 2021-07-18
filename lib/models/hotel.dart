class Hotel {
  late String id;
  late String name;
  late String location;
  late String image;
  late int numberOfRooms;
  late int phoneNumber;
  late int rate;
  Hotel({
    required this.id,
    required this.name,
    required this.numberOfRooms,
    required this.location,
    this.image = '',
    this.phoneNumber = 0,
    this.rate = -1,
  });
}

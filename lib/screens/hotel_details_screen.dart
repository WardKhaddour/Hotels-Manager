import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/editing_text_field.dart';
import '../widgets/hotel_details_item.dart';
import '../widgets/hotel_image.dart';
import '../widgets/hotel_rate.dart';

class HotelDetailsScreen extends StatefulWidget {
  static const routeName = '/hotel-details';

  @override
  _HotelDetailsScreenState createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _roomPriceController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _roomsFocusNode = FocusNode();
  final FocusNode _roomPriceFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _hotelsController = Get.find<HotelsController>();
  final _authController = Get.find<AuthController>();

  final Hotel? currentHotel =
      Get.arguments != null ? Get.arguments['hotel'] as Hotel : null;
  bool _enableEditing = false;

  void _saveForm() {
    // final isValid = _formKey.currentState!.validate();

    // if (!isValid) return;
    setState(() {
      _enableEditing = false;
    });
    final editiedHotel = Hotel(
      emptyRooms: int.parse(_roomsController.text),
      authorEmail: _authController.currentUser,
      id: currentHotel!.id,
      name: _nameController.text,
      location: _locationController.text,
      phoneNumber: int.parse(_phoneNumberController.text),
      imageUrl: currentHotel!.imageUrl,
      rates: currentHotel!.rates,
      roomsCount: int.parse(_roomsController.text),
      roomPrice: double.parse(_roomPriceController.text),
    );
    print('${editiedHotel.imageUrl}dadas');
    print(editiedHotel.rates);
    _hotelsController.editHotel(editiedHotel, currentHotel!.documentId!);
  }

  @override
  void initState() {
    super.initState();
    if (currentHotel == null) Get.back();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _roomsController.dispose();
    _hotelsController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    _nameFocusNode.dispose();
    _roomsFocusNode.dispose();
    _locationFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final currentHotel = _hotelsController.findById(_hotelId);
    _nameController.text = currentHotel!.name;
    _locationController.text = currentHotel!.location;
    _roomsController.text = currentHotel!.roomsCount.toString();
    _phoneNumberController.text = currentHotel!.phoneNumber.toString();
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            actions: [
              if (_authController.currentUser == currentHotel!.authorEmail)
                !_enableEditing
                    ? PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: TextButton(
                                  child: Text('Edit'),
                                  onPressed: () {
                                    Get.back();
                                    setState(() {
                                      _enableEditing = true;
                                    });
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    Get.back();
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text('Are you sure'),
                                        content: Text('Delete hotel?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Get.back();
                                              await _hotelsController
                                                  .deleteHotel(
                                                currentHotel!.documentId!,
                                              );
                                              Get.back();
                                            },
                                            child: Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: Get.back,
                                            child: Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])
                    : IconButton(
                        icon: Icon(Icons.save),
                        onPressed: _saveForm,
                      ),
            ],
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: HotelRate(
                rate: currentHotel!.rate,
                currentHotel: currentHotel!,
                enableEditing: _enableEditing,
              ),
              background: HotelImage(
                imageUrl: currentHotel!.imageUrl,
                // fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (_enableEditing)
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        EditingTextField(
                          hint: 'Name',
                          controller: _nameController,
                          currentFocusNode: _nameFocusNode,
                          nextFocusNode: _locationFocusNode,
                          validator: (_) {
                            if (_nameController.text.isEmpty) {
                              return 'Please input name';
                            }
                          },
                        ),
                        EditingTextField(
                          hint: 'Location',
                          controller: _locationController,
                          currentFocusNode: _locationFocusNode,
                          nextFocusNode: _roomsFocusNode,
                          validator: (_) {
                            if (_locationController.text.isEmpty) {
                              return 'Please input location';
                            }
                          },
                        ),
                        EditingTextField(
                          hint: 'Rooms',
                          controller: _roomsController,
                          currentFocusNode: _roomsFocusNode,
                          keyboardType: TextInputType.number,
                          nextFocusNode: _roomPriceFocusNode,
                          validator: (_) {
                            if (_roomsController.text.isEmpty ||
                                int.tryParse(_roomsController.text) == null) {
                              return 'Please input number of rooms';
                            }
                          },
                        ),
                        EditingTextField(
                          hint: 'Room Price',
                          controller: _roomPriceController,
                          currentFocusNode: _roomPriceFocusNode,
                          keyboardType: TextInputType.number,
                          nextFocusNode: _phoneNumberFocusNode,
                          validator: (_) {
                            if (_roomsController.text.isEmpty ||
                                double.tryParse(_roomsController.text) ==
                                    null) {
                              return 'Please input number of rooms';
                            }
                          },
                        ),
                        EditingTextField(
                          hint: 'Phone Number',
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number,
                          currentFocusNode: _phoneNumberFocusNode,
                          nextFocusNode: null,
                          saveForm: _saveForm,
                          validator: (_) {
                            if (_phoneNumberController.text.isEmpty ||
                                _phoneNumberController.text.runtimeType !=
                                    int) {
                              return 'Please input phone number';
                            }
                          },
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: <Widget>[
                      HotelDetailsItem(
                        leadingText: currentHotel!.name,
                        trailing: Icon(Icons.hotel),
                      ),
                      HotelDetailsItem(
                        leadingText: currentHotel!.location,
                        trailing: Icon(Icons.location_on),
                      ),
                      HotelDetailsItem(
                        leadingText: '${currentHotel!.roomsCount} Rooms',
                        trailing: Icon(Icons.meeting_room),
                      ),
                      HotelDetailsItem(
                        leadingText: '${currentHotel!.roomPrice} \$',
                        trailing: Icon(Icons.attach_money_outlined),
                      ),
                      HotelDetailsItem(
                        leadingText: '${currentHotel!.phoneNumber}',
                        trailing: IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () async {
                            if (await canLaunch(
                                "tel://${currentHotel!.phoneNumber}")) {
                              await launch(
                                  "tel://${currentHotel!.phoneNumber}");
                            } else {
                              print('Cannot make call');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

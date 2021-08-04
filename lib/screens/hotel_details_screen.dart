import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotels_manager/widgets/gradient_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/editing_text_field.dart';
import '../widgets/hotel_details_item.dart';

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

  final String _hotelId =
      Get.arguments != null ? Get.arguments['id'] as String : '';
  bool _enableEditing = false;

  void _saveForm() {
    // final isValid = _formKey.currentState!.validate();
    // if (!isValid) return;
    setState(() {
      _enableEditing = false;
    });
    final editiedHotel = Hotel(
      id: _hotelId,
      name: _nameController.text,
      location: _locationController.text,
      phoneNumber: int.parse(_phoneNumberController.text),
      imageUrl: _hotelsController.findById(_hotelId).imageUrl,
      rates: _hotelsController.findById(_hotelId).rates,
      roomsCount: int.parse(_roomsController.text),
      roomPrice: double.parse(_roomPriceController.text),
    );
    _hotelsController.editHotel(editiedHotel);
  }

  Widget _buildRate(double rate) {
    print(rate);
    return rate < 0
        ? Text('Not Rated')
        : Row(
            children: <Widget>[
              for (int i = 0; i < rate.toInt(); ++i)
                Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                ),
              if (rate.toInt() != rate)
                GradientIcon(
                    child: Icon(
                      Icons.star,
                    ),
                    colors: [
                      Colors.yellowAccent,
                      Colors.yellowAccent,
                      Colors.white
                    ])
            ],
          );
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
    final currentHotel = _hotelsController.findById(_hotelId);
    _nameController.text = currentHotel.name;
    _locationController.text = currentHotel.location;
    _roomsController.text = currentHotel.roomsCount.toString();
    _phoneNumberController.text = currentHotel.phoneNumber.toString();

    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            actions: [
              _authController.currentUser == currentHotel.authorEmail
                  ? IconButton(
                      icon: Icon(_enableEditing ? Icons.save : Icons.edit),
                      onPressed: _enableEditing
                          ? _saveForm
                          : () {
                              setState(() {
                                _enableEditing = true;
                              });
                            },
                    )
                  : SizedBox()
            ],
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: _buildRate(currentHotel.rate.toDouble()),
              background: Image.network(
                currentHotel.imageUrl,
                fit: BoxFit.cover,
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
                        leadingText: currentHotel.name,
                        trailing: Icon(Icons.hotel),
                      ),
                      HotelDetailsItem(
                        leadingText: currentHotel.location,
                        trailing: Icon(Icons.location_on),
                      ),
                      HotelDetailsItem(
                        leadingText: '${currentHotel.roomsCount} Rooms',
                        trailing: Icon(Icons.meeting_room),
                      ),
                      HotelDetailsItem(
                        leadingText: '${currentHotel.phoneNumber}',
                        trailing: IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () async {
                            if (await canLaunch(
                                "tel://${currentHotel.phoneNumber}")) {
                              await launch("tel://${currentHotel.phoneNumber}");
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
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
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _roomsFocusNode = FocusNode();
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
      rate: _hotelsController.findById(_hotelId).rate,
      roomsCount: int.parse(_roomsController.text),
    );
    _hotelsController.editHotel(editiedHotel);
  }

  Widget _buildRate(int rate) {
    return rate < 0
        ? Text('Not Rated')
        : Row(
            children: <Widget>[
              for (int i = 0; i < rate; ++i)
                Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                ),
              for (int i = rate; i < 5; ++i)
                Icon(
                  Icons.star,
                  color: Colors.white,
                )
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
              title: _buildRate(currentHotel.rate.toInt()),
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
                          nextFocusNode: _phoneNumberFocusNode,
                          validator: (_) {
                            if (_roomsController.text.isEmpty ||
                                _roomsController.text.runtimeType != int) {
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

class EditingTextField extends StatelessWidget {
  EditingTextField({
    required this.hint,
    required this.controller,
    required this.currentFocusNode,
    required this.validator,
    this.nextFocusNode,
    this.saveForm,
    this.keyboardType,
  });

  final TextEditingController controller;
  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? keyboardType;
  final VoidCallback? saveForm;
  final String hint;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autofocus: true,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        focusNode: currentFocusNode,
        decoration: kTextFieldDecoration.copyWith(
          hintText: hint,
        ),
        validator: validator,
        textInputAction: hint == 'Phone Number'
            ? TextInputAction.done
            : TextInputAction.next,
        onFieldSubmitted: (_) {
          nextFocusNode != null
              ? FocusScope.of(context).requestFocus(nextFocusNode)
              : saveForm;
        },
      ),
    );
  }
}

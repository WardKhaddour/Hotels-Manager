import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../services/firebase_storage_service.dart';
import '../services/image_selector.dart';
import '../widgets/editing_text_field.dart';
import '../widgets/location_text_field.dart';
import '../widgets/phone_number_text_field.dart';

class AddHotelScreen extends StatefulWidget {
  static const routeName = '/add-hotel';

  @override
  _AddHotelScreenState createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  final _hotelsController = Get.find<HotelsController>();

  final _authController = Get.find<AuthController>();

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

  bool _isLoading = false;

  bool _isUploadingImage = false;

  File? _image;

  String? _imageUrl;

  double _phoneNumber = 0.0;

  final hotelsController = Get.find<HotelsController>();

  void refresh() {
    _nameController.clear();
    _locationController.clear();
    _roomsController.clear();
    _roomPriceController.clear();
    _phoneNumberController.clear();
    _imageUrl = null;
    _image = null;
  }

  Future<void> addHotel() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final result = await FirebaseStorageServise.uploadImage(
          _nameController.text, _image!);
      await _hotelsController.addHotel(
        Hotel(
          emptyRooms: int.parse(_roomsController.text),
          authorEmail: _authController.currentUser,
          name: _nameController.text,
          location: _locationController.text,
          roomsCount: int.parse(_roomsController.text),
          id: DateTime.now().toIso8601String(),
          imageUrl: result != null ? result.imageUrl : '',
          rates: {},
          roomPrice: double.parse(_roomPriceController.text),
          // phoneNumber: int.parse(_phoneNumberController.text),
          phoneNumber: _phoneNumber.toInt(),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      Get.back();
      Get.snackbar('Done!', 'Hotel Added Succesfully');
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hotel'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refresh,
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: addHotel,
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 300,
                      width: 300,
                      child: _image != null
                          ? _isUploadingImage
                              ? CircularProgressIndicator()
                              : FadeInImage(
                                  placeholder:
                                      AssetImage('assets/images/hotel.png'),
                                  image: FileImage(_image!),
                                )
                          : Image(
                              image: AssetImage('assets/images/hotel.png'),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListTile(
                          leading: Text('Take Photo'),
                          trailing: Icon(Icons.camera),
                          onTap: () async {
                            setState(() {
                              _isUploadingImage = true;
                            });
                            await ImageSelector.selectImageFromCamera()
                                .then((value) => setState(() {
                                      _image = value;
                                      _isUploadingImage = false;
                                    }));
                            // final result =
                            //     await FirebaseStorageServise.uploadImage(
                            //         _nameController.text, image!);
                            // setState(() {
                            //   imageUrl = result!.imageUrl;
                            // });
                          },
                        ),
                        ListTile(
                          leading: Text('Pick Photo'),
                          trailing: Icon(Icons.photo_album),
                          onTap: () async {
                            await ImageSelector.selectImageFromGallery()
                                .then((value) => setState(() {
                                      _image = value;
                                    }));
                            // final result =
                            //     await FirebaseStorageServise.uploadImage(
                            //         _nameController.text, image!);
                            // setState(() {
                            //   imageUrl = result!.imageUrl;
                            // });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    EditingTextField(
                      hint: 'Name',
                      icon: Icon(Icons.title),
                      controller: _nameController,
                      currentFocusNode: _nameFocusNode,
                      nextFocusNode: _locationFocusNode,
                      validator: (_) {
                        if (_nameController.text.isEmpty) {
                          return 'Please input name';
                        }
                      },
                    ),
                    LocationTextField(
                      focusNode: _locationFocusNode,
                      nextFocusNode: _roomsFocusNode,
                      validator: (_) {
                        if (_locationController.text.isEmpty) {
                          return 'Please input location';
                        }
                      },
                      onSuggestionSelected: (value) {
                        _locationController.text = value.data!;
                        setState(() {});
                      },
                      controller: _locationController,
                      itemBuilder: (context, suggestion) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: suggestion,
                      ),
                      suggestionsCallback: (value) => hotelsController
                          .hotelsLocations
                          .map((e) => Text(e))
                          .toList(),
                    ),
                    // EditingTextField(
                    //   hint: 'Location',
                    //   icon: Icons.location_on,
                    //   controller: _locationController,
                    //   currentFocusNode: _locationFocusNode,
                    //   nextFocusNode: _roomsFocusNode,
                    //   validator: (_) {
                    //     if (_locationController.text.isEmpty) {
                    //       return 'Please input location';
                    //     }
                    //   },
                    // ),
                    EditingTextField(
                      hint: 'Rooms',
                      icon: Icon(Icons.meeting_room),
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
                      icon: Icon(Icons.attach_money),
                      controller: _roomPriceController,
                      currentFocusNode: _roomPriceFocusNode,
                      keyboardType: TextInputType.number,
                      nextFocusNode: _phoneNumberFocusNode,
                      validator: (_) {
                        if (_roomsController.text.isEmpty ||
                            double.tryParse(_roomsController.text) == null) {
                          return 'Please input number of rooms';
                        }
                      },
                    ),
                    PhoneNumberTextField(
                      controller: _phoneNumberController,
                      focusNode: _phoneNumberFocusNode,
                      nextFocusNode: null,
                      validator: (_) {
                        if (_phoneNumberController.text.isEmpty ||
                            _phoneNumberController.text.runtimeType != int) {
                          return 'Please input phone number';
                        }
                      },
                    ),
                    // Slider(
                    //     min: 0,
                    //     max: 10000000000000000000000,
                    //     value: phoneNumber,
                    //     onChanged: (value) {
                    //       phoneNumber = value;

                    //       setState(() {});
                    //     }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

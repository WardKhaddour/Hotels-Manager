import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/editing_text_field.dart';

class AddHotelScreen extends StatelessWidget {
  static const routeName = '\add-hotel';
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
  Future<void> addHotel() async {
    try {
      await _hotelsController.addHotel(
        Hotel(
          emptyRooms: int.parse(_roomsController.text),
          authorEmail: _authController.currentUser,
          name: _nameController.text,
          location: _locationController.text,
          roomsCount: int.parse(_roomsController.text),
          id: DateTime.now().toIso8601String(),
          imageUrl: '',
          rates: {},
          roomPrice: double.parse(_roomPriceController.text),
          phoneNumber: int.parse(_phoneNumberController.text),
        ),
      );
      Get.back();
    } on FirebaseException catch (e) {
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
            icon: Icon(Icons.check),
            onPressed: addHotel,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/images/hotel.png'),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListTile(
                        leading: Text('Take Photo'),
                        trailing: Icon(Icons.camera),
                        onTap: () {
                          //TODO take picture
                        },
                      ),
                      ListTile(
                        leading: Text('Pick Photo'),
                        trailing: Icon(Icons.photo_album),
                        onTap: () {
                          //TODO pick picture
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
                          double.tryParse(_roomsController.text) == null) {
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
                    // saveForm: _saveForm,
                    validator: (_) {
                      if (_phoneNumberController.text.isEmpty ||
                          _phoneNumberController.text.runtimeType != int) {
                        return 'Please input phone number';
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

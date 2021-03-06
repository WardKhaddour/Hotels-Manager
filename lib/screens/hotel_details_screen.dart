import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';
import '../widgets/delete_hotel_dialog.dart';
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

  Hotel? currentHotel =
      Get.arguments != null ? Get.arguments['hotel'] as Hotel : null;
  bool _enableEditing = false;
  bool _isLoading = false;
  Future<void> _saveForm() async {
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
    setState(() {
      _isLoading = true;
    });
    await _hotelsController.editHotel(editiedHotel, currentHotel!.documentId!);
    setState(() {
      currentHotel = editiedHotel;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (currentHotel == null) Get.back();
    _nameController.text = currentHotel!.name;
    _locationController.text = currentHotel!.location;
    _roomsController.text = currentHotel!.roomsCount.toString();
    _roomPriceController.text = currentHotel!.roomPrice.toString();
    _phoneNumberController.text = currentHotel!.phoneNumber.toString();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _roomsController.dispose();
    // _hotelsController.dispose();
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

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: CustomScrollView(
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
                                        DeleteHotelDialog(
                                          hotelsController: _hotelsController,
                                          currentHotel: currentHotel,
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
                // centerTitle: false,
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
                          EditingTextField(
                            hint: 'Location',
                            icon: Icon(Icons.location_on),
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
                                  double.tryParse(_roomsController.text) ==
                                      null) {
                                return 'Please input number of rooms';
                              }
                            },
                          ),
                          EditingTextField(
                            hint: 'Phone Number',
                            icon: Icon(Icons.phone),
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
                        Text(
                          '${currentHotel!.name}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Uchen',
                            // color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // HotelDetailsItem(
                        //   leadingText: currentHotel!.name,
                        //   trailing: Icon(Icons.hotel),
                        // ),
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
      ),
    );
  }
}

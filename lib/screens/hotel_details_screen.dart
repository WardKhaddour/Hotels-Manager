import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotels_manager/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/hotels_controller.dart';
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
  final _hotelsController = HotelsController();
  final String _hotelId =
      Get.arguments != null ? Get.arguments['id'] as String : '';
  bool _enableEditing = false;

  void _saveForm() {
    setState(() {
      _enableEditing = false;
    });
    //TODO save editing
  }

  Widget _buildRate(int rate) {
    return rate == -1
        ? Text('Not Rated')
        : Row(
            children: <Widget>[
              for (int i = 0; i < rate; i++)
                Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                ),
            ],
          );
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
              IconButton(
                icon: Icon(_enableEditing ? Icons.save : Icons.edit),
                onPressed: _enableEditing
                    ? _saveForm
                    : () {
                        setState(() {
                          _enableEditing = true;
                        });
                      },
              ),
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
                _enableEditing
                    ? Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            EditingTextField(
                                hint: 'Name',
                                controller: _nameController,
                                currentFocusNode: _nameFocusNode,
                                nextFocusNode: _locationFocusNode),
                            EditingTextField(
                                hint: 'Location',
                                controller: _locationController,
                                currentFocusNode: _locationFocusNode,
                                nextFocusNode: _roomsFocusNode),
                            EditingTextField(
                                hint: 'Rooms',
                                controller: _roomsController,
                                currentFocusNode: _roomsFocusNode,
                                nextFocusNode: _phoneNumberFocusNode),
                            EditingTextField(
                              hint: 'Phone Number',
                              controller: _phoneNumberController,
                              currentFocusNode: _phoneNumberFocusNode,
                              nextFocusNode: null,
                              saveForm: _saveForm,
                            ),
                          ],
                        ),
                      )
                    : Column(
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
                                  await launch(
                                      "tel://${currentHotel.phoneNumber}");
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
    this.nextFocusNode,
    this.saveForm,
  });

  final TextEditingController controller;
  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? saveForm;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autofocus: true,
        controller: controller,
        focusNode: currentFocusNode,
        decoration: kTextFieldDecoration.copyWith(
          hintText: hint,
        ),
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

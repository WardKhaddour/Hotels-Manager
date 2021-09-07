import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotels_controller.dart';
import '../models/hotel.dart';

class DeleteHotelDialog extends StatefulWidget {
  const DeleteHotelDialog({
    Key? key,
    required HotelsController hotelsController,
    required this.currentHotel,
  })   : _hotelsController = hotelsController,
        super(key: key);

  final HotelsController _hotelsController;
  final Hotel? currentHotel;

  @override
  _DeleteHotelDialogState createState() => _DeleteHotelDialogState();
}

class _DeleteHotelDialogState extends State<DeleteHotelDialog> {
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure'),
      content: Text('Delete hotel?'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: Get.back,
            child: Text('No'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isDeleting
              ? CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    setState(() {
                      _isDeleting = true;
                    });
                    await widget._hotelsController.deleteHotel(
                      widget.currentHotel!.documentId!,
                    );
                    setState(() {
                      _isDeleting = false;
                    });
                    Get.back();
                    Get.back();
                  },
                  child: Text('Yes'),
                ),
        ),
      ],
    );
  }
}

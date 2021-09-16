import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/hotels_controller.dart';
import '../countries_codes.dart';

class PhoneNumberTextField extends StatefulWidget {
  PhoneNumberTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
    required this.validator,
  }) : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String? Function(String?) validator;

  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final hotelsController = Get.find<HotelsController>();

  final countriesCodes = CountriesCodes.getCountriesCodes();

  final countries = CountriesCodes.getCountries();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        // autofocus: true,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        focusNode: widget.focusNode,
        decoration: kTextFieldDecoration.copyWith(
          hintText: 'Phone Number',
          prefixIcon: PopupMenuButton<String>(
            icon: Text('_'),
            itemBuilder: (context) => countries
                .map(
                  (e) => PopupMenuItem<String>(
                      value: countriesCodes[e],
                      child: Text('${countriesCodes[e]}  $e')),
                )
                .toList(),
            onSelected: (value) {
              print(value);
              print(value.toString().split('+').last);
              setState(() {
                widget.controller.text = value.toString().split('+').last;
              });
            },
          ),
          icon: Icon(Icons.phone),
        ),
        validator: widget.validator,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        },
      ),
    );
  }
}

// class PhoneNumberTextField extends StatelessWidget {
  
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final FocusNode? nextFocusNode;
//   final String? Function(String?) validator;
//   final hotelsController = Get.find<HotelsController>();
//   final countriesCodes = CountriesCodes.getCountriesCodes();
//   @override
//   Widget build(BuildContext context) {
//     return EditingTextField(
//       hint: 'Phone Number',
//       icon: Icon(Icons.phone),
//       // prefixIcon: DropdownButton<String>(
//       //   items: CountriesCodes.getCountries()
//       //       .map((e) => DropdownMenuItem<String>(
//       //             child: ListTile(
//       //               title: Text(e),
//       //               leading: Text(countriesCodes[e]!),
//       //             ),
//       //           ))
//       //       .toList(),
//         hint: Text('Country'),
//       ),
//       controller: controller,
//       keyboardType: TextInputType.number,
//       currentFocusNode: focusNode,
//       nextFocusNode: null,
//       // saveForm: _saveForm,
//       validator: validator,
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../constants.dart';

class LocationTextField extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final String? Function(String?) validator;
  final void Function(Text) onSuggestionSelected;
  final TextEditingController controller;
  final Widget Function(BuildContext, Text) itemBuilder;
  final FutureOr<Iterable<Text>> Function(String) suggestionsCallback;

  LocationTextField(
      {Key? key,
      required this.focusNode,
      required this.nextFocusNode,
      required this.validator,
      required this.onSuggestionSelected,
      required this.controller,
      required this.itemBuilder,
      required this.suggestionsCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: kTextFieldDecoration.copyWith(
            hintText: 'Location',
            icon: Icon(Icons.location_on),
          ),
        ),
        validator: validator,
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: itemBuilder,
        suggestionsCallback: suggestionsCallback,
      ),
    );
  }
}

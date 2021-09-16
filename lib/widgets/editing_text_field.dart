import 'package:flutter/material.dart';
import '../constants.dart';

class EditingTextField extends StatelessWidget {
  EditingTextField({
    required this.hint,
    required this.controller,
    required this.currentFocusNode,
    required this.validator,
    required this.icon,
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
  final Widget icon;
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
          icon: icon,
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

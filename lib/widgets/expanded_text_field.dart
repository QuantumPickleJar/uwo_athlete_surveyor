import 'package:flutter/material.dart';

/// Written before [expanded] was discovered on TextField...
///     
/// Outlined TextField that expands to handle multiple lines of input
/// 
/// Optionally accepts leading [leadingIcon] and trailing [trailingIcon] icons 
class ExpandedTextField extends StatelessWidget {
  
  final String labelText;
  final String? hintText;
  
  final Icon? leadingIcon;
  final Icon? trailingIcon;

/// Creates an outlined text field with the specified [labelText] and [hintText].
///
/// The [labelText] is used as the label text for the text field.
/// The **optional** [hintText], gets shown until input received
  const ExpandedTextField(
    {super.key, required this.labelText, this.hintText, 
    this.leadingIcon, this.trailingIcon });

    @override
    Widget build(BuildContext context) {
      return TextField(
        decoration: InputDecoration(
          prefixIcon: leadingIcon,
          suffixIcon: trailingIcon,
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        maxLines: null,
      );
  }
}

import 'package:athlete_surveyor/resources/colors.dart';
import 'package:flutter/material.dart';

// The default style for an AppBar with modifiable title.
AppBar defaultAppBar({required BuildContext buildContext, required String title, required bool hasBackButton, IconButton? actionButton})
{
  return  AppBar(
            //title: Text(title),
            //centerTitle: true,
            backgroundColor: titanYellow,
            leading: //if hasBackButton==true then the button will generate, otherwise 'null' is used.
              hasBackButton ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_outlined, 
                    color: Colors.black), 
                  onPressed:(){ Navigator.pop(buildContext); })) 
              : null,
            actions: [
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: actionButton)]);
}

/// An ElevatedButton that can have it's visibility toggled based on the provided boolean parameter 'visibilityToggle'.
/// This can be a one-time check or can be used to dynamically decided if the button is available based on the current
/// environment.
Widget toggleVisibleButton({required bool visibilityToggle, 
                            required void Function() onPressed, 
                            required String buttonText})
{
  return Visibility(
    visible: visibilityToggle,
    child: ElevatedButton(
      onPressed: onPressed, 
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
      child: SizedBox(
        child: Center(child: Text(
          buttonText, 
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold))))));
}

/// The default style for a TextFormField.
TextFormField defaultTextFormField({required TextEditingController controller, 
                                    required String? Function(String?) validator, 
                                    required String hintText,
                                    required bool obscureText})
{
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      hintText: hintText));
}

// The default style for an IconButton that should be used with the defaultAppBar widget.
IconButton defaultActionButton({required IconData actionIcon, required void Function() onPressed})
{
  return IconButton(
    icon: Icon(
      actionIcon, 
      color: Colors.black), 
    onPressed: onPressed);
}

// The default style of the ListViewDivider.
const Divider defaultListViewDivider = Divider
(
  thickness: 2.0,
  color: titanYellow
);
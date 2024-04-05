  import 'package:flutter/material.dart';

/// Use to navigate to any page by supplying the existing context from "Widget build" and the page type.
  void navigateToPage(BuildContext context, Widget page)
  {
    Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context) => page)
    );
  }
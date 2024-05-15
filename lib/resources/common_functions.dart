// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Resource file for functions used repeatedly in the app.
/// Bugs: n/a
/// Reflection: n/a

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
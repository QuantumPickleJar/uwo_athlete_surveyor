// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Temporary page from prototyping intended to show what an individually selected form's Question-Answer pairs would look like during review.
/// Bugs: n/a
/// Reflection: Still a temporary model. If this line is still present in submission then we likely didn't have time to finish some feature or other.

import 'package:athlete_surveyor/data_objects/previous_form_qa.dart';
import 'package:flutter/material.dart';

// Temporary model
class IndividualFormExaminationModel extends ChangeNotifier
{
  final List<PreviousFormQAPairs> pairsList =
  [
    PreviousFormQAPairs("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua?",
                        "Facilisi etiam dignissim diam quis enim lobortis scelerisque."),
    PreviousFormQAPairs("Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt?",
                        "Tortor posuere ac ut consequat semper viverra nam libero justo."),
    PreviousFormQAPairs("Donec adipiscing tristique risus nec feugiat in fermentum posuere urna?",
                        "Sit amet tellus cras adipiscing enim eu turpis."),
    PreviousFormQAPairs("Velit euismod in pellentesque massa placerat duis ultricies lacus?",
                        "Ut eu sem integer vitae justo eget magna."),
    PreviousFormQAPairs("Pellentesque habitant morbi tristique senectus et netus et?",
                        "Neque egestas congue quisque egestas diam in arcu cursus."),
    PreviousFormQAPairs("Id venenatis a condimentum vitae sapien pellentesque habitant morbi tristique?",
                        "Nisl vel pretium lectus quam id."),
    PreviousFormQAPairs("Sit amet facilisis magna etiam tempor orci?",
                        "Volutpat commodo sed egestas egestas fringilla phasellus faucibus scelerisque."),
    PreviousFormQAPairs("Egestas tellus rutrum tellus pellentesque eu tincidunt tortor aliquam?",
                        "Donec ac odio tempor orci dapibus."),
    PreviousFormQAPairs("Id semper risus in hendrerit gravida rutrum quisque non?",
                        "Diam phasellus vestibulum lorem sed risus."),
    PreviousFormQAPairs("Auctor augue mauris augue neque gravida in fermentum?",
                        "Viverra aliquet eget sit amet tellus cras adipiscing.")
  ];
}
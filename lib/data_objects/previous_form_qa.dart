// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Temporary data-object from prototyping used to represent the Question-Answer pairs of a previously completed form; intended for use with student profiles.
/// Bugs: n/a
/// Reflection: Still a temporary model. If this line is still present in submission then we likely didn't have time to finish some feature or other.

// Likely temporary data object for GUI presentation.
class PreviousFormQAPairs
{
  final String _question;
  final String _answer;

  String get question => _question;
  String get answer => _answer;

  PreviousFormQAPairs(this._question, this._answer);
}
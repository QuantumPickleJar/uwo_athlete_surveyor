// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Temporary data-object from prototyping used to represent a previously completed form's summarized information.
/// Bugs: n/a
/// Reflection: Still a temporary model. If this line is still present in submission then we likely didn't have time to finish some feature or other.

// A data object for storing the information related to a single form.
class PreviousForm 
{
  final String _formName;
  final String _associatedSport;
  final DateTime _formDateReceived;
  final DateTime _formDateCompleted;

  String get formName => _formName;
  String get sport => _associatedSport;
  String get dateReceived => _formDateReceived.toString().substring(0,10);
  String get dateCompleted => _formDateCompleted.toString().substring(0,10);

  PreviousForm(this._formName, this._associatedSport, this._formDateReceived, this._formDateCompleted);
}
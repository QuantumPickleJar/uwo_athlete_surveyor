// A data object for storing the information related to a single form.
/// TODO: Implement the Form model
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
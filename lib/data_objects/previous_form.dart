/* Author - Joshua */
class PreviousForm 
{
  final String _formName;
  final DateTime _formDateReceived;
  final DateTime _formDateCompleted;

  String get formName => _formName;
  String get dateReceived => _formDateReceived.toString();
  String get dateCompleted => _formDateCompleted.toString();

  PreviousForm(this._formName, this._formDateReceived, this._formDateCompleted);
}
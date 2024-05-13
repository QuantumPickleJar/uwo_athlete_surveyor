// Email data object; subject to change drastically.
class Email
{
  final DateTime _received;
  final String _from;
  final String _subject;
  final String _body;
  final String _firstName;
  final String _lastName;

  String get receivedDate => _received.toString().substring(0,10);
  String get from => _from;
  String get subject => _subject;
  String get body => _body;
  String get senderFirstName => _firstName;
  String get senderLastName => _lastName;

  Email(this._received, this._from, this._subject, this._body, this._firstName, this._lastName);
}
// Email data object; subject to change drastically.
class Email
{
  final DateTime _received;
  final String _from;
  final String _subject;
  final String _body;

  String get receivedDate => _received.toString().substring(0,10);
  String get from => _from;
  String get subject => _subject;
  String get body => _body;

  Email(this._received, this._from, this._subject, this._body);
}
// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A data-object for inbox messages.
/// Bugs: n/a
/// Reflection: n/a

/// Message data object for Inbox.
class Message
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

  Message(this._received, this._from, this._subject, this._body, this._firstName, this._lastName);
}
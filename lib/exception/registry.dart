/// Exception in case there is no Session.
class SessionMissingException implements Exception {
  final String description = 'There is no valid session.';

  SessionMissingException();

  @override
  String toString() => description;
}

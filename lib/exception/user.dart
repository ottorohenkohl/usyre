/// Exception in case the username is in use.
class UsernameTakenException implements Exception {
  final String description = 'The desired username is in use.';

  UsernameTakenException();

  @override
  String toString() => description;
}

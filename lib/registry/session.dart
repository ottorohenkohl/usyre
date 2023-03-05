import 'package:usyre/registry/registry.dart';
import 'package:usyre/user/user.dart';
import 'package:uuid/uuid.dart';

/// Class for storing session details.
///
/// Stores the current user using the session.
/// The Session.sessionID is used for temporal authentication.
class Session {
  /// Credentials.
  final String sessionID = Uuid().v4();

  /// User information.
  final User user;

  /// Validity information.
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();

  Session({
    required this.user,
  });

  /// Function for validating a Session.
  bool isValid() {
    return created.difference(updated) < Registry.duration;
  }
}

import 'package:usyre/exception/registry.dart';
import 'package:usyre/registry/session.dart';
import 'package:usyre/user/user.dart';

/// Class for handling Sessions.
///
/// Can store and manipulate Sessions.
/// Sessions are stored in a static Session list.
class Registry {
  /// Globally static list of Sessions.
  static final sessions = <Session>[];

  /// Globally defined Session duration.
  static Duration duration = Duration(minutes: 30);

  Registry();

  /// Function for adding a Session.
  Session add(User user) {
    var session = Session(user: user);

    sessions.removeWhere(
      (element) {
        return element.user.containerID == user.containerID;
      },
    );

    sessions.add(session);

    return session;
  }

  /// Function for retrieving a Session.
  Session get(String sessionID) {
    var session = sessions.singleWhere(
      (element) {
        return element.sessionID == sessionID;
      },
      orElse: () {
        throw SessionMissingException();
      },
    );

    return session;
  }

  /// Function for retrieving a Session.
  void delete(String sessionID) {
    sessions.removeWhere(
      (element) {
        return element.sessionID == sessionID;
      },
    );
  }
}

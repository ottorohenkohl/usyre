import 'dart:convert';

import 'package:usyre/exception/generic.dart';
import 'package:usyre/registry/registry.dart';
import 'package:usyre/registry/session.dart';

/// Class for handling HTTP sessions.
///
/// The SessionTemplate class is supposed to interact with the
/// registry lib while handling requests.
class SessionTemplate {
  SessionTemplate();

  /// Method for loading the sessionID from a HTTP request.
  Session load(String data) {
    var body;
    try {
      body = jsonDecode(data);
    } catch (exception) {
      throw BadRequestException();
    }

    if (body['sessionID'] == null) {
      throw ForbiddenException();
    }

    var session = Registry().get(body['sessionID']);

    if (!session.isValid()) {
      throw ForbiddenException();
    }

    session.updated = DateTime.now();

    return session;
  }
}

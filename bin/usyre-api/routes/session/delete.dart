import 'package:shelf/shelf.dart';
import 'package:usyre/registry/registry.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Logs out an User by destroying his session.
///
/// Checks for a valid Session and deletes it from the Registry.
Future<Response> sessionDelete(Request request) async {
  var data = await request.readAsString();
  try {
    var session = SessionTemplate().load(data);

    Registry().delete(session.sessionID);

    return ResponseTemplate().success(null);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

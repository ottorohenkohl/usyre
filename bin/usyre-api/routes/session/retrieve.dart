import 'package:shelf/shelf.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Returns Session information.
///
/// Checks the User's session, looks it up inside of the Registry
/// and returns Session information.
Future<Response> sessionRetrieve(Request request, String sessionID) async {
  var data = await request.readAsString();

  try {
    var session = SessionTemplate().load(data);

    session.updated = DateTime.now();

    var body = {
      'sessionID': session.sessionID,
      'userID': session.user.containerID,
      'created': session.created.toString(),
      'updated': session.updated.toString(),
    };

    return ResponseTemplate().success(body);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

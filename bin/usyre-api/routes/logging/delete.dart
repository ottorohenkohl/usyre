import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/logging/record.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Deletes an existing Record.
///
/// Checks the User's permissions and
/// creates deletes an existing Record.
Future<Response> recordDelete(Request request, String recordID) async {
  var data = await request.readAsString();

  try {
    var session = SessionTemplate().load(data);

    if (session.user.role != Role.admin) {
      throw ForbiddenException();
    }

    var record = (await Storage().load(Options(type: Record))).singleWhere(
      (element) {
        return (element as Record).containerID == recordID;
      },
      orElse: () {
        throw NotFoundException();
      },
    );

    await Storage().clear(record);

    return ResponseTemplate().success(null);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

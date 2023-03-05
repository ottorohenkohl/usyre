import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/logging/logger.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/logging/record.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Returns Record information.
///
/// Checks the User's session, looks it up inside of the Registry
/// and returns Record information from storage.
Future<Response> recordRetrieve(Request request, String recordID) async {
  var data = await request.readAsString();

  try {
    var session = SessionTemplate().load(data);

    if (session.user.role != Role.admin) {
      throw ForbiddenException();
    }

    await Logger().clean();

    var record = (await Storage().load(Options(type: Record))).singleWhere(
      (element) {
        return (element as Record).containerID == recordID;
      },
      orElse: () {
        throw NotFoundException();
      },
    ) as Record;

    var body = {
      'created': record.created.toString(),
      'urgency': record.urgency.name,
      'detail': record.detail,
      'header': record.header,
      'tracer': record.tracer,
    };

    return ResponseTemplate().success(body);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/user/user.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Returns User information.
///
/// Checks the User's session, looks it up inside of the Registry
/// and returns User information from storage.
Future<Response> userRetrieve(Request request, String username) async {
  var data = await request.readAsString();

  try {
    var session = SessionTemplate().load(data);

    if (session.user.username != username && session.user.role != Role.admin) {
      throw ForbiddenException();
    }

    var user = (await Storage().load(Options(type: User))).singleWhere(
      (element) {
        return (element as User).username == username;
      },
      orElse: () {
        throw NotFoundException();
      },
    ) as User;

    var body = {
      'flag': user.flag.name,
      'role': user.role.name,
      'username': user.username,
      'forename': user.forename,
      'lastname': user.lastname,
    };

    return ResponseTemplate().success(body);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

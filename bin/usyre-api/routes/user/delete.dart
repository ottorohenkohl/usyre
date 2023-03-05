import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/user/user.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Deletes an existing User.
///
/// Checks the User's permissions and
/// creates deletes an existing User.
Future<Response> userDelete(Request request, String username) async {
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
    );

    await Storage().clear(user);

    return ResponseTemplate().success(null);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

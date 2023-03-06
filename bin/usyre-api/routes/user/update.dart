import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/flag.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/user/user.dart';

import '../../template/response.dart';
import '../../template/session.dart';

/// Creates a new User.
///
/// Checks the User's permissions and
/// creates a new User.
Future<Response> userUpdate(Request request, String username) async {
  var data = await request.readAsString();

  try {
    var session = SessionTemplate().load(data);

    if (session.user.role == Role.guest) {
      throw ForbiddenException();
    }

    if (session.user.username != username && session.user.role != Role.admin) {
      throw ForbiddenException();
    }

    Flag? flag;
    Role? role;
    String? password;
    String? forename;
    String? lastname;

    try {
      var json = jsonDecode(data);

      if (json['flag'] != null) {
        flag = Flag.values.byName(json['flag']);
      }

      if (json['role'] != null) {
        role = Role.values.byName(json['role']);
      }

      password = json['password'];
      forename = json['forename'];
      lastname = json['lastname'];
    } catch (e) {
      throw BadRequestException();
    }

    var user = (await Storage().load(Options(type: User))).singleWhere(
      (element) {
        return (element as User).username == username;
      },
      orElse: () {
        throw NotFoundException();
      },
    ) as User;

    user
      ..flag = flag ?? user.flag
      ..role = role ?? user.role
      ..password = password ?? user.password
      ..forename = forename ?? user.forename
      ..lastname = lastname ?? user.lastname;

    await Storage().store(user);

    return ResponseTemplate().success(null);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

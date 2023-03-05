import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
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
Future<Response> userCreate(Request request) async {
  var data = await request.readAsString();

  try {
    var session = SessionTemplate().load(data);

    if (session.user.role != Role.admin) {
      throw ForbiddenException();
    }

    Flag? flag;
    Role? role;
    String username;
    String password;
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

      username = json['username'];
      password = json['password'];
      forename = json['forename'];
      lastname = json['lastname'];
    } catch (e) {
      throw BadRequestException();
    }

    if (!RegExp(r"^[a-z0-9_.-]{3,15}$").hasMatch(username)) {
      throw BadRequestException();
    }

    var user = User(
      flag: flag ?? Flag.foreign,
      role: role ?? Role.user,
      username: username,
      password: password,
      forename: forename ?? '',
      lastname: lastname ?? '',
    );

    await Storage().store(user);

    return ResponseTemplate().success(null);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

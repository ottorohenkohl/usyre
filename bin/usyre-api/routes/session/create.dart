import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/registry/registry.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/user.dart';

import '../../template/response.dart';

/// Login in an User through creating a new session.
///
/// Checks the User's credentials, creates a new Session and stores
/// it inside of the Registry.
Future<Response> sessionCreate(Request request) async {
  var data = await request.readAsString();

  try {
    String username;
    String password;

    try {
      var json = jsonDecode(data);

      username = json['username'];
      password = json['password'];
    } catch (e) {
      throw BadRequestException();
    }

    try {
      var session = Registry.sessions.singleWhere((element) {
        var user = element.user;
        return user.username == username && user.password == password;
      }, orElse: () {
        throw ForbiddenException();
      });

      var body = {
        'sessionID': session.sessionID,
      };

      return ResponseTemplate().success(body);
    } catch (e) {}

    var user = (await Storage().load(Options(type: User))).singleWhere(
      (element) {
        return (element as User).username == username;
      },
      orElse: () {
        throw ForbiddenException();
      },
    ) as User;

    if (user.password != password) {
      throw ForbiddenException();
    }

    var session = await Registry().add(user);

    var body = {
      'sessionID': session.sessionID,
    };

    return ResponseTemplate().success(body);
  } catch (exception, stacktrace) {
    return ResponseTemplate().errored(null, exception, stacktrace);
  }
}

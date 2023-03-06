import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:usyre/exception/generic.dart';
import 'package:usyre/logging/logger.dart';
import 'package:usyre/logging/record.dart';
import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/flag.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/user/user.dart';

import '../routes/logging/delete.dart';
import '../routes/logging/retrieve.dart';
import '../routes/logging/retrieveAll.dart';
import '../routes/session/create.dart';
import '../routes/session/delete.dart';
import '../routes/session/retrieve.dart';
import '../routes/user/create.dart';
import '../routes/user/delete.dart';
import '../routes/user/retrieve.dart';
import '../routes/user/retrieveAll.dart';
import '../routes/user/update.dart';
import '../template/response.dart';

/// Entrypoint of the usyre-api submodule.
void entry({List<String> arguments = const []}) async {
  var host = Platform.environment['API_HOST'] ?? InternetAddress.anyIPv4;
  var port = Platform.environment['API_PORT'] ?? '8080';
  var path = Platform.environment['API_PATH'] ?? '/';

  try {
    int.parse(port);
  } catch (e) {
    Logger().toOverall(
      Record(
        urgency: Urgency.cautious,
        header: 'Port invalid',
        detail: 'The given port $port is not a valid port',
      ),
    );
  }

  await createAdmin();

  var router = Router(notFoundHandler: noRoute);

  router.delete('${path}logging/<recordID>', recordDelete);
  router.get('${path}logging/<recordID>', recordRetrieve);
  router.get('${path}logging', recordRetrieveAll);

  router.post('${path}session', sessionCreate);
  router.delete('${path}session', sessionDelete);
  router.get('${path}session/<sessionID>', sessionRetrieve);

  router.post('${path}user', userCreate);
  router.delete('${path}user/<username>', userDelete);
  router.get('${path}user/<username>', userRetrieve);
  router.get('${path}user', userRetrieveAll);
  router.patch('${path}user/<username>', userUpdate);

  serve(router, host, int.parse(port));

  Logger().toOverall(
    Record(
      urgency: Urgency.relevant,
      header: 'Starting HTTP endpoint',
      detail: 'Launching under http://$host:$port$path',
    ),
  );
}

/// Function for creating a admin user based on environment variables.
Future<void> createAdmin() async {
  var username = Platform.environment['ADMIN_USERNAME'];
  var password = Platform.environment['ADMIN_PASSWORD'];

  if (username == null) {
    return;
  }

  if (password == null) {
    return;
  }

  var existing = (await Storage().load(Options(type: User))).where(
    (element) {
      return (element as User).username == username;
    },
  );

  if (existing.isNotEmpty) {
    var user = (existing.single as User)..password = password;

    await Storage().store(user);
  } else {
    var user = User(
      username: username,
      password: password,
      flag: Flag.temporally,
      role: Role.admin,
    );

    await Storage().store(user);
  }
}

/// Function for returning a standard not found response.
Future<Response> noRoute(Request request) async {
  return ResponseTemplate().errored(null, NotFoundException(), null);
}

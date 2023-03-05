import 'package:usyre/logging/logger.dart';
import 'package:usyre/logging/record.dart';
import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/container.dart';
import 'package:usyre/storage/converter.dart';
import 'package:usyre/storage/datasheet.dart';
import 'package:usyre/user/flag.dart';
import 'package:usyre/user/role.dart';
import 'package:usyre/user/user.dart';

/// Converter for an User object.
///
/// The UserConverter should implement some way of
/// importing and exporting an User object from and to
/// the Datasheet type. For a list of possible types to be used inside of
/// the Datasheet.form map, take a look at the Database.types map.
/// Key values can only be alphanumeric.
class UserConverter extends ContainerConverter {
  UserConverter();

  @override
  void reset() {
    container = User();
    datasheet = Datasheet();
  }

  @override
  Container importDatasheet() {
    super.importDatasheet();

    (container as User)
      ..forename = datasheet.data['forename'] ?? User().forename
      ..lastname = datasheet.data['lastname'] ?? User().lastname
      ..password = datasheet.data['password'] ?? User().password
      ..username = datasheet.data['username'] ?? User().username;

    try {
      (container as User)
        ..flag = Flag.values.byName(datasheet.data['flag'])
        ..role = Role.values.byName(datasheet.data['role']);
    } catch (exception) {
      Logger().toOverall(
        Record(
          urgency: Urgency.relevant,
          header: 'Error while importing User Datasheet',
          detail: 'Could not load User ${container.containerID}',
        ),
      );
    }

    return container;
  }

  @override
  Datasheet exportDatasheet() {
    super.exportDatasheet();

    layoutDatasheet();

    datasheet
      ..data['flag'] = (container as User).flag.name
      ..data['role'] = (container as User).role.name
      ..data['forename'] = (container as User).forename
      ..data['lastname'] = (container as User).lastname
      ..data['password'] = (container as User).password
      ..data['username'] = (container as User).username;

    return datasheet;
  }

  @override
  Datasheet layoutDatasheet() {
    super.layoutDatasheet();

    datasheet
      ..form['flag'] = String
      ..form['role'] = String
      ..form['forename'] = String
      ..form['lastname'] = String
      ..form['password'] = String
      ..form['username'] = String;

    return datasheet;
  }
}

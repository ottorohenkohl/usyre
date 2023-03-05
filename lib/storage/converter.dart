import 'package:usyre/logging/logger.dart';
import 'package:usyre/logging/record.dart';
import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/container.dart';
import 'package:usyre/storage/datasheet.dart';

/// Converter for the Container object.
///
/// The ContainerConverter should implement some way of
/// importing and exporting a Container object from and to
/// the Datasheet type. For possible types of the Datasheet.form map,
/// take a look at the Database.types map.
/// Key values can only be alphanumeric.
class ContainerConverter {
  /// Container and Datasheet for conversation; The Container type has to match.
  Container container = Container();
  Datasheet datasheet = Datasheet();

  ContainerConverter() {
    reset();
  }

  /// Function for overwriting the runtimeType.
  Type get matching {
    return container.runtimeType;
  }

  /// Resetting the ContainerConverter for a new instance.
  void reset() {
    container = Container();
    datasheet = Datasheet();
  }

  /// For importing and parsing a Datasheet to a Container.
  Container importDatasheet() {
    container
      ..containerID = datasheet.data['containerID'] ?? Container().containerID
      ..description = datasheet.data['description'] ?? Container().description;

    try {
      container
        ..created = DateTime.parse(datasheet.data['created'])
        ..updated = DateTime.parse(datasheet.data['updated']);
    } catch (exception) {
      Logger().toOverall(
        Record(
          urgency: Urgency.relevant,
          header: 'Error while importing Container Datasheet',
          detail: 'Could not load Container ${container.containerID}',
        ),
      );
    }

    return container;
  }

  /// For exporting a Container instance to a Datasheet.
  Datasheet exportDatasheet() {
    layoutDatasheet();

    datasheet
      ..data['created'] = container.created.toString()
      ..data['updated'] = container.updated.toString()
      ..data['containerID'] = container.containerID
      ..data['description'] = container.description;

    return datasheet;
  }

  /// Generate a Datasheet only with filled form map.
  Datasheet layoutDatasheet() {
    datasheet
      ..form['created'] = String
      ..form['updated'] = String
      ..form['containerID'] = String
      ..form['description'] = String;

    return datasheet;
  }
}

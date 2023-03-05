import 'package:usyre/exception/storage.dart';
import 'package:usyre/storage/container.dart';
import 'package:usyre/storage/converter.dart';
import 'package:usyre/storage/database.dart';
import 'package:usyre/storage/options.dart';

/// Main class of the storage lib.
///
/// The Storage class is supposed to be the interface
/// for interacting with the storage lib. Objects can be
/// stored and retrieved through generic functions in case
/// they're implementing the Container interface.
class Storage {
  /// Globally defined list; You need to add a Converter for each Container.
  static final converters = <ContainerConverter>[];

  Storage();

  /// Stores an object to the Database; Overwrites an existing entry.
  Future<void> store(Container container) async {
    var converter = converters.singleWhere(
      (element) {
        return element.matching == container.runtimeType;
      },
      orElse: () {
        throw ConverterMissingException();
      },
    );

    await container.verify();
    await container.update();

    converter.reset();
    converter.container = container;

    var datasheet = converter.exportDatasheet();

    await Database().delete(datasheet);
    await Database().insert(datasheet);
  }

  /// Delete an object from Database; Skips if no object is found.
  Future<void> clear(Container container) async {
    var converter = converters.singleWhere(
      (element) {
        return element.matching == container.runtimeType;
      },
      orElse: () {
        throw ContainerMissingException();
      },
    );

    converter.reset();
    converter.container = container;

    var datasheet = converter.exportDatasheet();

    await Database().delete(datasheet);
  }

  /// Load a single object; Throws exception if there's no unique object.
  Future<Container> loadSingle(Options options) async {
    var potential = await load(options);
    var requested = potential.where(
      (element) {
        return true;
      },
    );

    if (requested.length == 1) {
      return potential.single;
    }

    if (requested.isEmpty) {
      throw ContainerMissingException();
    }

    if (options.solo == true) {
      throw ContainerMissingException();
    }

    return potential.first;
  }

  /// Load a list of object; The result is filtered through the Options class.
  Future<List<Container>> load(Options options) async {
    var selectedConverters = converters.where(
      (element) {
        return options.type == null || options.type == element.matching;
      },
    );

    var containers = <Container>[];
    for (var converter in selectedConverters) {
      (await Database().load(converter.layoutDatasheet())).forEach(
        (element) {
          converter.reset();
          converter.datasheet = element;

          containers.add(converter.importDatasheet());
        },
      );
    }

    if (options.description != null) {
      containers.removeWhere(
        (element) {
          return options.description != element.description;
        },
      );
    }

    if (options.containerID != null) {
      containers.removeWhere(
        (element) {
          return options.containerID != element.containerID;
        },
      );
    }

    return containers;
  }
}

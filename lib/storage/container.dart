import 'package:usyre/exception/storage.dart';
import 'package:uuid/uuid.dart';

/// Interface for storable objects.
///
/// Storable objects have to implement the Container
/// interface to be usable within the
/// Storage class.
class Container {
  /// Values containing chronological access information.
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();

  /// Container information.
  String containerID = Uuid().v4();
  String description;

  Container({
    this.description = '',
  });

  /// Function to be called on update; Should throw exception on fail.
  Future<void> update() async {
    updated = DateTime.now();
  }

  /// Function to be called on creation; Should throw exception on fail.
  Future<void> verify() async {
    if (updated.isBefore(created)) {
      throw ContainerInvalidException();
    }
  }
}

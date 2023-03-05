import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/container.dart';

/// Object for storing a single Log entry.
///
/// The Record class is supposed to hold the data of
/// a single Log entry. Because of extending the Container
/// Interface, it can be stored through the storage lib.
/// For further details take a look at the storage lib.
class Record extends Container {
  /// Time of creation.
  DateTime created = DateTime.now();

  /// Level of the entry.
  Urgency urgency;

  /// Entry data.
  String detail;
  String header;
  String tracer;

  Record({
    this.urgency = Urgency.standard,
    this.detail = '',
    this.header = '',
    this.tracer = '',
  });

  @override
  Future<void> update() async {}

  @override
  Future<void> verify() async {}
}

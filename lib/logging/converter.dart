import 'package:usyre/logging/logger.dart';
import 'package:usyre/logging/record.dart';
import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/container.dart';
import 'package:usyre/storage/converter.dart';
import 'package:usyre/storage/datasheet.dart';

/// Converter for an Record object.
///
/// The RecordConverter should implement some way of
/// importing and exporting an Record object from and to
/// the Datasheet type. For a list of possible types to be used inside of
/// the Datasheet.form map, take a look at the Database.types map.
/// Key values can only be alphanumeric.
class RecordConverter extends ContainerConverter {
  RecordConverter();

  @override
  void reset() {
    container = Record();
    datasheet = Datasheet();
  }

  @override
  Container importDatasheet() {
    super.importDatasheet();

    (container as Record)
      ..detail = datasheet.data['detail'] ?? Record().detail
      ..header = datasheet.data['header'] ?? Record().header
      ..tracer = datasheet.data['tracer'] ?? Record().tracer;

    try {
      (container as Record)
        ..urgency = Urgency.values.byName(datasheet.data['urgency'])
        ..created = DateTime.parse(datasheet.data['created']);
    } catch (exception) {
      Logger().toOverall(
        Record(
          urgency: Urgency.relevant,
          header: 'Error while importing Record Datasheet',
          detail: 'Could not load Record ${container.containerID}',
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
      ..data['created'] = (container as Record).created.toString()
      ..data['urgency'] = (container as Record).urgency.name
      ..data['detail'] = (container as Record).detail
      ..data['header'] = (container as Record).header
      ..data['tracer'] = (container as Record).tracer;

    return datasheet;
  }

  @override
  Datasheet layoutDatasheet() {
    super.layoutDatasheet();

    datasheet
      ..form['created'] = String
      ..form['urgency'] = String
      ..form['detail'] = String
      ..form['header'] = String
      ..form['tracer'] = String;

    return datasheet;
  }
}

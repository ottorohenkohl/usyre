import 'dart:io';

import 'package:usyre/logging/record.dart';
import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/container.dart';
import 'package:usyre/storage/options.dart';
import 'package:usyre/storage/storage.dart';

/// Class for logging messages.
///
/// The Logger class provides a way of logging messages to different sources.
/// The messages are logged, based on a predefined level.
class Logger {
  /// Defining default log level.
  static Urgency urgency = Urgency.standard;

  /// Defining cleanup parameters.
  static int lengthStandard = 50;
  static int lengthRelevant = 50;
  static int lengthCautious = 50;

  Logger();

  /// Cleans old log records.
  Future<void> clean() async {
    var records = await Storage().load(Options(type: Record));

    var deletesStandard = records.length - lengthStandard;
    var deletesRelevant = records.length - lengthRelevant;
    var deletesCautious = records.length - lengthCautious;

    for (Container element in records) {
      var record = element as Record;

      if (record.urgency == Urgency.standard && deletesStandard > 0) {
        deletesStandard--;

        await Storage().clear(record);
      }

      if (record.urgency == Urgency.standard && deletesRelevant > 0) {
        deletesRelevant--;

        await Storage().clear(record);
      }

      if (record.urgency == Urgency.standard && deletesCautious > 0) {
        deletesCautious--;

        await Storage().clear(record);
      }
    }
  }

  /// Logs to all sources
  void toOverall(Record record) {
    toConsole(record);
    toStorage(record);
  }

  /// Only write a Record to console.
  void toConsole(Record record) {
    if (record.urgency.index < urgency.index) {
      return;
    }

    stdout.write('${record.created.toString()}        [');
    stdout.write('${record.urgency.name.toUpperCase()}]: ');
    stdout.write('${record.header}; ');
    stdout.write('${record.detail}\n');

    if (record.tracer != '') {
      stdout.write('${record.tracer}\n');
    }
  }

  /// Only write a Record to storage.
  void toStorage(Record record) {
    Storage().store(record);
  }
}

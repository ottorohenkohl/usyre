import 'dart:io';

import 'package:usyre/logging/converter.dart';
import 'package:usyre/logging/logger.dart';
import 'package:usyre/logging/urgency.dart';
import 'package:usyre/storage/converter.dart';
import 'package:usyre/storage/database.dart';
import 'package:usyre/storage/storage.dart';
import 'package:usyre/user/converter.dart';

import 'usyre-api/entry/entry.dart' as usyre_api;
import 'usyre-cli/entry/entry.dart' as usyre_cli;

/// Entrypoint of the Usyre application.
void main(List<String> arguments) async {
  Storage.converters.add(ContainerConverter());
  Storage.converters.add(RecordConverter());
  Storage.converters.add(UserConverter());

  loadParameters(arguments);
  loadSubmodules(arguments);
}

/// Function for parsing environment variables.
void loadParameters(List<String> arguments) {
  Database.location = Platform.environment['DB_LOCATION'] ?? Database.location;
  Database.database = Platform.environment['DB_DATABASE'] ?? Database.database;
  Database.username = Platform.environment['DB_USERNAME'] ?? Database.username;
  Database.password = Platform.environment['DB_PASSWORD'] ?? Database.password;

  if (Platform.environment['LOG_LEVEL'] != null) {
    Logger.urgency = Urgency.values.byName(Platform.environment['LOG_LEVEL']!);
  }

  try {
    if (Platform.environment['DB_PORT'] != null) {
      Database.port = int.parse(Platform.environment['DB_PORT']!);
    }
  } catch (e) {
    throw Exception('Invalid Environment variable "DB_PORT".');
  }

  try {
    if (Platform.environment['LOGGING_LENGTH_STANDARD'] != null) {
      Logger.lengthStandard = int.parse(
        Platform.environment['LOGGING_LENGTH_STANDARD']!,
      );
    }
  } catch (e) {
    throw Exception('Invalid Environment variable "LOGGING_LENGTH_STANDARD".');
  }

  try {
    if (Platform.environment['LOGGING_LENGTH_RELEVANT'] != null) {
      Logger.lengthRelevant = int.parse(
        Platform.environment['LOGGING_LENGTH_RELEVANT']!,
      );
    }
  } catch (e) {
    throw Exception('Invalid Environment variable "LOGGING_LENGTH_RELEVANT".');
  }

  try {
    if (Platform.environment['LOGGING_LENGTH_CAUTIOUS'] != null) {
      Logger.lengthCautious = int.parse(
        Platform.environment['LOGGING_LENGTH_CAUTIOUS']!,
      );
    }
  } catch (e) {
    throw Exception('Invalid Environment variable "LOGGING_LENGTH_CAUTIOUS".');
  }
}

/// Function for loading all the applications submodules.
void loadSubmodules(List<String> arguments) {
  usyre_cli.entry(arguments: arguments);
  usyre_api.entry(arguments: arguments);
}

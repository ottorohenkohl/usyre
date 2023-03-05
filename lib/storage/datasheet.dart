import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:usyre/exception/storage.dart';
import 'package:usyre/storage/database.dart';

/// Class for storing objects.
///
/// The Datasheet class is supposed to hold object data
/// in a specific, predefined way. Through the Datasheet class,
/// objects can be stored persistently.
class Datasheet {
  /// For definition of the layout of the Datasheet.
  final form = <String, Type>{};
  final data = <dynamic, dynamic>{};

  Datasheet();

  /// Get a hash of the form map; Two Datasheet of same form have a same hash.
  String get hash {
    var sorted = SplayTreeMap.from(form);
    var summed = '';

    sorted.keys.forEach(
      (element) {
        summed += element;
        summed += sorted[element].toString();
      },
    );

    var encode = utf8.encode(summed);
    var hashed = md5.convert(encode);

    return hashed.toString();
  }

  /// Validate that the types defined in form are matching those in data.
  Future<void> validate() async {
    if (form.keys.isEmpty) {
      throw DatasheetInvalidException();
    }

    for (String element in form.keys) {
      if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(element) == false) {
        throw DatasheetInvalidException();
      }

      if (Database.types.keys.contains(form[element]) == false) {
        throw DatasheetInvalidException();
      }

      if (data[element].runtimeType != form[element]) {
        throw DatasheetInvalidException();
      }
    }
  }
}
